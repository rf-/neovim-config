-- [nfnl] fnl/local/lsp.fnl
local _local_1_ = require("std.functional")
local map = _local_1_.map
local tbl = require("std.table")
local local_plugins_lspconfig = require("local.plugins.lspconfig")
local _local_2_ = require("local.plugins.sidekick")
local sidekick_setup = _local_2_.setup
local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd
local clear_autocmds = vim.api.nvim_clear_autocmds
local get_current_buf = vim.api.nvim_get_current_buf
create_augroup("local-lsp-auto-format", {clear = true})
local function is_array(tbl0)
  return not not tbl0[1]
end
local function map_vals(func, tbl0)
  local function _3_(_241, _242)
    return func(_242)
  end
  return map(_3_, tbl0)
end
local function create_auto_format_autocmd(extra_opts)
  local extra_opts0 = (extra_opts or {})
  local all_extra_opts
  if is_array(extra_opts0) then
    all_extra_opts = extra_opts0
  else
    all_extra_opts = {extra_opts0}
  end
  local all_opts
  local function _5_(_241)
    return tbl.merge({formatting_options = {timeout_ms = 5000}}, _241)
  end
  all_opts = map_vals(_5_, all_extra_opts)
  local auto_format_callback
  local function _6_()
    for _, opts in ipairs(all_opts) do
      vim.lsp.buf.format(opts)
    end
    return nil
  end
  auto_format_callback = _6_
  clear_autocmds({event = "BufWritePre", buffer = get_current_buf(), group = "local-lsp-auto-format"})
  create_autocmd("BufWritePre", {buffer = get_current_buf(), callback = auto_format_callback, group = "local-lsp-auto-format"})
  return nil
end
local function auto_format_on_save(filetypes, extra_opts)
  local callback
  local function _7_()
    return create_auto_format_autocmd(extra_opts)
  end
  callback = _7_
  for _, filetype in ipairs(filetypes) do
    create_autocmd("FileType", {pattern = filetype, callback = callback})
  end
  return nil
end
local function setup(server_name, config)
  return local_plugins_lspconfig.setup(server_name, config)
end
local function enable_sidekick()
  return sidekick_setup()
end
return {["auto-format-on-save"] = auto_format_on_save, setup = setup, ["enable-sidekick"] = enable_sidekick}
