-- [nfnl] fnl/local/commands.fnl
local g = vim["g"]
local command = vim.api["nvim_command"]
local create_command = vim.api["nvim_create_user_command"]
local list_wins = vim.api["nvim_list_wins"]
local win_get_config = vim.api["nvim_win_get_config"]
local win_close = vim.api["nvim_win_close"]
local u = require("local.utils")
local function rg(opts)
  local results = u.system(("rg --no-heading --line-number " .. opts.args))
  g.__rg_results = results
  command("cexpr g:__rg_results")
  return command("copen")
end
create_command("Rg", rg, {nargs = "*", complete = "dir"})
local function sg(opts)
  local results = u.system(("sg --heading never --pattern " .. opts.args))
  g.__sg_results = results
  command("cexpr g:__sg_results")
  return command("copen")
end
create_command("Sg", sg, {nargs = "*", complete = "dir"})
local function close_floating_windows()
  for _, win in ipairs(list_wins()) do
    local config = win_get_config(win)
    if (config.relative ~= "") then
      win_close(win, false)
    else
    end
  end
  return nil
end
return create_command("CloseFloatingWindows", close_floating_windows, {})
