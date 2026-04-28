local install = require("dbee.install")
local api = require("dbee.api")
local config = require("dbee.config")

---@toc dbee.ref.contents

---@mod dbee.ref Dbee Reference
---@brief [[
---Database Client for NeoVim.
---@brief ]]

local dbee = {
  api = {
    core = api.core,
    ui = api.ui,
  },
}

---Setup function.
---Needs to be called before calling any other function.
---@param cfg? Config
function dbee.setup(cfg)
  -- merge with defaults
  local merged = config.merge_with_default(cfg)

  -- validate config
  config.validate(merged)

  api.setup(merged)
end

---Toggle dbee UI.
---If a different layout is currently open, closes it before opening the target layout.
---@param layout? Layout optional layout to toggle; defaults to the configured window_layout
function dbee.toggle(layout)
  local current_config = api.current_config()
  local target_layout = layout or current_config.window_layout
  local current_layout = current_config.window_layout

  -- close the currently active layout if it differs from the target
  if current_layout ~= target_layout and current_layout and current_layout.is_open and current_layout:is_open() then
    current_layout:close()
  end

  current_config.window_layout = target_layout

  if target_layout:is_open() then
    dbee.close()
  else
    dbee.open()
  end
end

---Open dbee UI. If already opened, reset window layout.
function dbee.open()
  if api.current_config().window_layout:is_open() then
    return api.current_config().window_layout:reset()
  end
  api.current_config().window_layout:open()
end

---Close dbee UI.
function dbee.close()
  if not api.current_config().window_layout:is_open() then
    return
  end
  api.current_config().window_layout:close()
end

---Check if dbee UI is open or not.
---@return boolean
function dbee.is_open()
  return api.current_config().window_layout:is_open()
end

---Execute a query on current connection.
---Convenience wrapper around some api functions that executes a query on
---current connection and pipes the output to result UI.
---@param query string
function dbee.execute(query)
  local conn = api.core.get_current_connection()
  if not conn then
    error("no connection currently selected")
  end

  local call = api.core.connection_execute(conn.id, query)
  api.ui.result_set_call(call)

  dbee.open()
end

---Store currently displayed result.
---Convenience wrapper around some api functions.
---@param format string format of the output -> "csv"|"json"|"table"
---@param output string where to pipe the results -> "file"|"yank"|"buffer"
---@param opts { from: integer, to: integer, extra_arg: any }
function dbee.store(format, output, opts)
  local call = api.ui.result_get_call()
  if not call then
    error("no current call to store")
  end

  api.core.call_store_result(call.id, format, output, opts)
end

---Supported install commands.
---@alias install_command
---| '"wget"'
---| '"curl"'
---| '"bitsadmin"'
---| '"go"'
---| '"cgo"'

---Install dbee backend binary.
---@param command? install_command Preffered install command
---@see install_command
function dbee.install(command)
  install.exec(command)
end

return dbee
