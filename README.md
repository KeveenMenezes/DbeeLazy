# DbeeLazy 🐝

> A floating-first fork of [nvim-dbee](https://github.com/kndndrj/nvim-dbee) — database client for Neovim, inspired by lazygit and lazydocker.

![Backend](https://img.shields.io/badge/go-backend-lightblue?style=for-the-badge&logo=go&logoColor=white)
![Frontend](https://img.shields.io/badge/lua-frontend-blue?style=for-the-badge&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/license-GPL--3.0-green?style=for-the-badge)

![Screenshot](assets/screenshot.png)

## What's Different from nvim-dbee

| Feature | nvim-dbee | DbeeLazy |
|---|---|---|
| Default layout | Split panels | **Floating panel (88% width)** |
| Float border | None | **Rounded** |
| Results page size | 100 rows | **20 rows** |
| Toggle | Simple open/close | **Layout-aware switch** |
| Result rendering | Sync on `retrieving` | **Async on `archived` (safer)** |
| Bufferline integration | Manual | **Built-in helper module** |
| Autosave guard | Manual | **Built-in helper module** |

## Installation

**requires nvim >= 0.10**

### lazy.nvim

```lua
{
  "KeveenMenezes/DbeeLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  build = function()
    require("dbee").install()
  end,
  keys = {
    { "<leader>Du", function() require("dbee").toggle() end, desc = "Dbee UI" },
  },
  config = function()
    require("dbee").setup()
  end,
},
```

### Optional: bufferline tab name integration

```lua
-- in your bufferline plugin spec:
{
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    local dbee_bl = require("dbee.integrations.bufferline")
    opts.options = opts.options or {}
    opts.options.name_formatter = dbee_bl.name_formatter(opts.options.name_formatter)
  end,
},
```

### Optional: autosave guard

```lua
local dbee_autosave = require("dbee.integrations.autosave")

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
  callback = function(event)
    if dbee_autosave.should_skip(event.buf) then return end
    -- your save logic here
  end,
})
```

## API

```lua
require("dbee").open()
require("dbee").close()
require("dbee").toggle(optional_layout)  -- closes any other open layout first
require("dbee").execute(query)
require("dbee").store(format, output, opts)  -- "csv"|"json"|"table" → "file"|"yank"|"buffer"
```

## Connections

```lua
require("dbee").setup {
  sources = {
    require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
    require("dbee.sources").FileSource:new(vim.fn.stdpath("state") .. "/dbee/persistence.json"),
  },
}
```

Export connections as JSON via `DBEE_CONNECTIONS`:

```sh
export DBEE_CONNECTIONS='[{"name":"My DB","type":"postgres","url":"postgres://user:pass@localhost/db"}]'
```

## Keymaps (defaults)

| Key | Action |
|---|---|
| `BB` | Execute query (visual = selection, normal = whole buffer) |
| `L / H` | Next / previous result page |
| `E / F` | Last / first result page |
| `yaj / yac` | Yank row as JSON / CSV |
| `q` | Close layout |
| `?` | Toggle help |

## License

GPL v3 — fork of [nvim-dbee](https://github.com/kndndrj/nvim-dbee) by [kndndrj](https://github.com/kndndrj). See [LICENSE](LICENSE).
