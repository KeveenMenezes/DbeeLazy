---@mod dbee.ref.integrations Optional Integrations
---@brief [[
---DbeeLazy ships optional integration modules for popular Neovim plugins.
---None of these are loaded automatically; require only what you need.
---
---Available integrations:
--- - |dbee.ref.integrations.bufferline| — akinsho/bufferline.nvim tab name support
--- - |dbee.ref.integrations.autosave|   — guard helper for autosave plugins
---@brief ]]

return {
  bufferline = require("dbee.integrations.bufferline"),
  autosave = require("dbee.integrations.autosave"),
}
