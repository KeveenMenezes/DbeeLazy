---@mod dbee.ref.integrations.bufferline Bufferline Integration
---@brief [[
---Optional integration with akinsho/bufferline.nvim.
---
---Displays a friendly name for the dbee tab in the bufferline tab bar.
---Requires that bufferline is configured with a custom `name_formatter`.
---
---Example setup inside your bufferline opts:
---
---```lua
---opts = function(_, opts)
---  local dbee_bufferline = require("dbee.integrations.bufferline")
---  opts.options = opts.options or {}
---  opts.options.name_formatter = dbee_bufferline.name_formatter(opts.options.name_formatter)
---end
---```
---@brief ]]

local M = {}

---Returns a `name_formatter` function compatible with bufferline.nvim.
---Wraps an optional existing formatter, prepending dbee tab name resolution.
---@param existing_formatter? fun(element: table): string|nil
---@return fun(element: table): string|nil
function M.name_formatter(existing_formatter)
  return function(element)
    if element.tabnr then
      local tabpage = vim.api.nvim_list_tabpages()[element.tabnr]
      if tabpage then
        local ok, name = pcall(vim.api.nvim_tabpage_get_var, tabpage, "dbee_tab_name")
        if ok and type(name) == "string" and name ~= "" then
          return name
        end
      end
    end

    if existing_formatter then
      return existing_formatter(element)
    end
  end
end

return M
