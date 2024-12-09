-- [nfnl] Compiled from fnl/local/commands.fnl by https://github.com/Olical/nfnl, do not edit.
local g = vim["g"]
local command = vim.api["nvim_command"]
local create_command = vim.api["nvim_create_user_command"]
local u = require("local.utils")
local function _1_(opts)
  local results = u.system(("rg --nogroup " .. opts.args))
  g.__rg_results = results
  command("cexpr g:__rg_results")
  return command("copen")
end
create_command("Rg", _1_, {nargs = "*", complete = "dir"})
local function _2_(opts)
  local results = u.system(("sg --heading never --pattern " .. opts.args))
  g.__sg_results = results
  command("cexpr g:__sg_results")
  return command("copen")
end
return create_command("Sg", _2_, {nargs = "*", complete = "dir"})
