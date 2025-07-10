# 🧠 ChatPy.nvim

**ChatPy.nvim** is your Neovim bridge to a next-level Python agent environment, powered by the **Google Agent Development Kit (AGDK)**.  
Think of it as your coding sidekick, chillin' right inside your editor.

> ⚠️ Heads up: this is still a WIP (Work In Progress), built for my own daily use. Expect bugs, chaos, and pure potential.

---

## 🚀 What It Do?

ChatPy.nvim is designed to turn your Neovim into a smart, context-aware playground for agent-based development. With it, you can:
- Chat with your agent directly in your editor.
- Build agent workflows inside Neovim.
- Eventually code-manipulate, sandbox, highlight, and personalize your whole dev experience like a boss.

---

## 📦 Features (and what’s cookin’ 👨‍🍳)

### ✅ Already Working
- Basic connection to Python-based agent runtime (using Google ADK).
- Agent chat inside Neovim buffers.

### 🔜 Coming Soon (aka my endless TODO list):
- [ ] Full-on config support for agents (`chatpy.toml or chatpy.yaml` maybe?)
- [ ] 🔁 Code manipulation commands (refactor, fix, generate code... you know the vibe)
- [ ] 💾 Memory & Personalization support (your agent, your rules)
- [ ] MCP integrations
- [ ] 🧠 Multi-agent support (yes, you can build your squad)
- [ ] 🎨 Better syntax highlighting for agent responses
- [ ] 🛡️ Input/output safety handling (no more rogue scripts)
- [ ] 🧪 Sandboxed code execution (run stuff without blowing up your system)

---

## 🛠️ Setup (kinda alpha, don’t @ me)

```lua
-- Lazy.nvim setup example
{
  "yourusername/chatpy.nvim",
  config = function()
    require("chatpy").setup()
  end
}
```

You’ll also need to have Python + Google’s Agent Development Kit set up.  
(Guide coming soon-ish… or you can just read the source, it’s not *that* cursed.)

---

## 🤝 Contributing?

Not open for PRs *yet*, but feel free to drop ideas, feature requests, or just vibe in the Issues tab.  
Or fork it. Go wild.

---

## 📓 License

MIT. Do whatever. But if you build something cool with it, hmu on X (Twitter? idk what we call it now).
