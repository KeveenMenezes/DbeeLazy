---@mod dbee.ref.integrations.autosave Autosave Integration
---@brief [[
---Utility helpers for plugins that implement autosave behaviour
---(e.g. auto-writing buffers on `InsertLeave` / `TextChanged`).
---
---Dbee uses special buffer types and writes query state to a state directory
---that should never be auto-saved by external plugins.
---Use `M.should_skip(buf)` as a guard inside your autosave autocmd callback.
---
---Example:
---
---```lua
---local dbee_autosave = require("dbee.integrations.autosave")
---
---vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
---  callback = function(event)
---    if dbee_autosave.should_skip(event.buf) then return end
---    -- your save logic here
---  end,
---})
---```
---@brief ]]

local M = {}

---Returns true when the given buffer should be excluded from autosave.
---Skips dbee filetype buffers and any buffer whose path sits inside the
---dbee state directory.
---@param buf integer buffer handle
---@return boolean
function M.should_skip(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return true
  end

  local bo = vim.bo[buf]
  local name = vim.api.nvim_buf_get_name(buf)
  local dbee_state_dir = vim.fn.stdpath("state") .. "/dbee/"

  return bo.filetype == "dbee" or name:find(dbee_state_dir, 1, true) == 1
end

return M
