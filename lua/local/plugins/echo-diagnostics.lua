-- [nfnl] Compiled from fnl/local/plugins/echo-diagnostics.fnl by https://github.com/Olical/nfnl, do not edit.
local echo_diagnostics = require("echo-diagnostics")
local autocmd = vim.api["nvim_create_autocmd"]
echo_diagnostics.setup({show_diagnostic_number = false})
local function _1_()
  echo_diagnostics.echo_line_diagnostic()
  return nil
end
return autocmd("CursorHold", {pattern = "*", callback = _1_})
