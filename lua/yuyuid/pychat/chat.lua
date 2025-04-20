-- TODO dont use index for inject window, use name
local M = {}

-- Use the standard 'uv' alias for vim.loop
M.uv = vim.loop
M.fn = vim.fn -- Access vim functions like executable()

-- Create pipes
M.stdin = M.uv.new_pipe(false)  -- writable
M.stdout = M.uv.new_pipe(false) -- readable

-- Start the process
M.handle = nil

M.buffers = {}
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
      local header_body_split = data:find("\r\n\r\n")
      local body = data:sub(header_body_split + 4)
      local clean = body:gsub("\n$", "")
      local ok, parsed = pcall(vim.json.decode, clean)
      if ok and parsed then
        -- TODO make a separate function to process agent return
        if (parsed.method == "sendMessage") then
          table.insert(M.chatHistory, { role = "system", content = parsed.result.content })
          vim.schedule(function()
            local last_line = vim.api.nvim_buf_line_count(M.buffers[1])
            vim.api.nvim_buf_set_lines(M.buffers[1], last_line, last_line, true, {
              "",
              M.chatHistory[#M.chatHistory].role .. " : " .. M.chatHistory[#M.chatHistory].content
            })
          end)
        end
      else
        vim.notify("Parse Agent Message Fail")
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

function M.sendMessage()
  -- Send Message to Python Rpc Server (sendMessage)
  -- vim.api.nvim_buf_get_lines(buf, firstline, new_lastline, true)
  local message = ""
  local lines = vim.api.nvim_buf_get_lines(M.buffers[2], 0, -1, true)
  for i, line in ipairs(lines) do
    message = message .. line
  end
  table.insert(M.chatHistory, { role = "user", content = message })

  local json_data = M.fn.json_encode({
    jsonrpc = "2.0",
    id = M.request_id,
    method = "sendMessage",
    params = M.chatHistory
  })
  M.request_id = M.request_id + 1

  local msg = "Content-Length: " .. #json_data .. "\r\n\r\n" .. json_data
  M.stdin:write(msg)
end

function M.closeConnection()
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

-- TODO, investigate if buf still exist
function M.setup()
  local codeWin = vim.api.nvim_get_current_win()
  table.insert(M.windows, codeWin)

  local chatHistoryBuf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(chatHistoryBuf, 0, 0, true, {
    M.chatHistory[1].role .. " : " .. M.chatHistory[1].content
  })
  table.insert(M.buffers, chatHistoryBuf)
  vim.cmd("vsplit")
  vim.cmd("wincmd l")
  local chatHistoryWin = vim.api.nvim_get_current_win()    -- Get the current window ID
  table.insert(M.windows, chatHistoryWin)
  vim.api.nvim_win_set_buf(chatHistoryWin, chatHistoryBuf) -- Set the buffer to this window

  local chatInputBuf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(chatInputBuf, 0, 0, true, { "Chat: " })
  table.insert(M.buffers, chatInputBuf)
  vim.cmd("split")
  vim.cmd("wincmd j")
  local chatInputWin = vim.api.nvim_get_current_win()  -- Get the current window ID
  table.insert(M.windows, chatInputWin)
  vim.api.nvim_win_set_buf(chatInputWin, chatInputBuf) -- Set the buffer to this window

  vim.keymap.set('n', '<CR>', function()
    -- your command here, e.g., send chat
    M.sendMessage()
  end, { buffer = chatInputBuf, noremap = true, silent = true })
end

return M
