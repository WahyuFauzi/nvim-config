-- TODO dont use index for inject window, use name
local M = {}

local function parse_response(response)
  local header_body_split = response:find("\r\n\r\n")
  local body = response:sub(header_body_split + 4)
  local clean = body:gsub("\n$", "")
  local ok, parsed = pcall(vim.json.decode, clean)
  if ok and parsed then
    return parsed
  else
    vim.notify("Error when parse response json from chatpy")
  end
end

-- Use the standard 'uv' alias for vim.loop
M.uv = vim.loop
M.fn = vim.fn

-- Create pipes
M.stdin = M.uv.new_pipe(false)  -- writable
M.stdout = M.uv.new_pipe(false) -- readable

-- Start the process
M.handle = nil
M.buffers = {}
M.waiting_for_request = false
M.windows = {}
M.request_id = 1
M.chatHistory = {
  {
    role = "system",
    content = "You are a coding assistant",
  },
}

function M.initialize()
  M.handle = M.uv.spawn("/var/home/yuyuid/.config/nvim/lua/yuyuid/pychat/env/bin/python3", {
    args = { "/var/home/yuyuid/.config/nvim/lua/yuyuid/pychat/main.py" },
    stdio = { M.stdin, M.stdout, nil },
  }, function(code, signal)
    vim.notify("Start RPC Server with code " .. code .. " and signal " .. signal)
    M.stdin:close()
    M.stdout:close()
    M.handle:close()
  end)

  M.stdout:read_start(function(err, data)
    assert(not err, err)
    if data then
      local parsed = parse_response(data)
      if (parsed.method == "sendMessage") then
        local content = parsed.result.content
        table.insert(M.chatHistory, { role = "system", content = content })
        vim.schedule(function()
          vim.api.nvim_buf_set_option(M.buffers["chatHistoryBuf"], 'modifiable', true)
          local last_line = vim.api.nvim_buf_line_count(M.buffers["chatHistoryBuf"])

          -- Split the content into lines
          local content_lines = vim.split(content, '\n')

          -- Prepend "System: " to the first line and add the other lines
          local lines_to_insert = {}
          table.insert(lines_to_insert, "System: " .. content_lines[1])
          for i = 2, #content_lines do
              table.insert(lines_to_insert, content_lines[i])
          end

          -- Insert the lines into the buffer
          vim.api.nvim_buf_set_lines(M.buffers["chatHistoryBuf"], last_line, last_line, true, lines_to_insert)

          vim.api.nvim_buf_set_option(M.buffers["chatHistoryBuf"], 'modifiable', false)
          M.waiting_for_request = false
        end)
      end
    end
  end)

  local json_data = M.fn.json_encode({
    jsonrpc = "2.0",
    id = M.request_id,
    method = "initialize",
    params = {}
  })
  M.request_id = M.request_id + 1

  local msg = "Content-Length: " .. #json_data .. "\r\n\r\n" .. json_data
  M.stdin:write(msg)
end

function M.send_message()
  -- Send Message to Python Rpc Server (sendMessage)
  -- vim.api.nvim_buf_get_lines(buf, firstline, new_lastline, true)
  local message = ""
  local lines = vim.api.nvim_buf_get_lines(M.buffers["chatInputBuf"], 0, -1, true)
  lines[1] = lines[1]:gsub("^Chat ?:%s*", "")
  for i, line in ipairs(lines) do
    message = message .. line .. "\n"  -- optional: keep newlines if needed
  end
  message = vim.trim(message)
  table.insert(M.chatHistory, { role = "User", content = message })

  local json_data = M.fn.json_encode({
    jsonrpc = "2.0",
    id = M.request_id,
    method = "sendMessage",
    params = M.chatHistory
  })
  M.request_id = M.request_id + 1

  vim.api.nvim_buf_set_option(M.buffers["chatHistoryBuf"], 'modifiable', true)
  local last_line = vim.api.nvim_buf_line_count(M.buffers["chatHistoryBuf"])
  vim.api.nvim_buf_set_lines(M.buffers["chatHistoryBuf"], last_line, last_line, true, {
    "Chat: " .. message
  })
  vim.api.nvim_buf_set_option(M.buffers["chatHistoryBuf"], 'modifiable', true)

  local msg = "Content-Length: " .. #json_data .. "\r\n\r\n" .. json_data
  M.stdin:write(msg)
  M.waiting_for_request = true
  vim.api.nvim_buf_set_lines(M.buffers["chatInputBuf"], 0, -1, false, {}) -- clears
  vim.api.nvim_buf_set_lines(M.buffers["chatInputBuf"], 0, 1, false, { "Chat: " })
end

function M.close_connection()
  -- close connection to Python Rpc Server (closeConnection)
  local json_data = M.fn.json_encode({
    jsonrpc = "2.0",
    id = M.request_id,
    method = "close",
    params = {}
  })
  M.request_id = M.request_id + 1

  local msg = "Content-Length: " .. #json_data .. "\r\n\r\n" .. json_data
  M.stdin:write(msg)
end

function M.close_chatpy()
  local chatHistoryWin = M.windows["chatHistoryWin"]
  local chatInputWin = M.windows["chatInputWin"]
  local chatHistoryBuf = M.buffers["chatHistoryBuf"]
  local chatInputBuf = M.buffers["chatInputBuf"]

  -- Close windows if still open
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win == chatHistoryWin or win == chatInputWin then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end

  -- Delete buffers if valid
  for _, buf in ipairs({ chatHistoryBuf, chatInputBuf }) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  -- Optional: clear references
  M.windows["chatHistoryWin"] = nil
  M.windows["chatInputWin"] = nil
  M.buffers["chatHistoryBuf"] = nil
  M.buffers["chatInputBuf"] = nil
end

-- TODO, investigate if buf still exist
function M.setup()
  local codeWin = vim.api.nvim_get_current_win()
  M.windows["codeWin"] = codeWin

  local chatHistoryBuf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(chatHistoryBuf, 0, 1, false, {
    "System : " .. M.chatHistory[1].content
  })
  vim.api.nvim_buf_set_option(chatHistoryBuf, 'modifiable', false)
  M.buffers["chatHistoryBuf"] = chatHistoryBuf
  vim.cmd("vsplit")
  vim.cmd("wincmd l")
  vim.cmd("vertical resize 61")
  local chatHistoryWin = vim.api.nvim_get_current_win()    -- Get the current window ID
  vim.api.nvim_set_current_win(chatHistoryWin)
  vim.api.nvim_win_set_buf(chatHistoryWin, chatHistoryBuf) -- Set the buffer to this window

  local chatInputBuf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(chatInputBuf, 0, 1, false, { "Chat: " })
  M.buffers["chatInputBuf"] = chatInputBuf
  vim.cmd("split")
  vim.cmd("wincmd j")
  vim.cmd("horizontal resize 10")
  local chatInputWin = vim.api.nvim_get_current_win()  -- Get the current window ID
  M.windows["chatInputWin"] = chatInputWin
  vim.api.nvim_win_set_buf(chatInputWin, chatInputBuf) -- Set the buffer to this window

  vim.keymap.set('n', '<CR>', function()
    if (not M.waiting_for_request) then
      M.send_message()
    else
      vim.notify("ChatPy still waiting for return from Agent")
    end
  end, { buffer = M.buffers["chatInputBuf"], noremap = true, silent = true })


  -- Autocmd to handle if either chat window closes
  vim.api.nvim_create_autocmd("WinClosed", {
    group = vim.api.nvim_create_augroup("ChatAutoClose", { clear = true }),
    callback = function(args)
      local closed_win = tonumber(args.match) -- closed window ID

      if closed_win == chatHistoryWin or closed_win == chatInputWin then
        -- Kill the other window if it's still open
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local winid = win

          if winid == chatHistoryWin or winid == chatInputWin then
            if winid ~= closed_win then
              pcall(vim.api.nvim_win_close, winid, true)
            end
          end
        end

        -- Wipe both chat buffers if still loaded
        for _, buf in ipairs({ chatHistoryBuf, chatInputBuf }) do
          if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end
    end,
  })
end

return M
