-- [nfnl] fnl/local/lsp.fnl
local tbl = require("std.table")
local local_plugins_lspconfig = require("local.plugins.lspconfig")
local create_augroup = vim.api["nvim_create_augroup"]
local create_autocmd = vim.api["nvim_create_autocmd"]
local clear_autocmds = vim.api["nvim_clear_autocmds"]
local get_current_buf = vim.api["nvim_get_current_buf"]
create_augroup("local-lsp-auto-format", {clear = true})
local function create_auto_format_autocmd(extra_opts)
  local merged_options = tbl.merge({formatting_options = {timeout_ms = 5000}}, (extra_opts or {}))
  local auto_format_callback
  local function _1_()
    vim.lsp.buf.format(merged_options)
    return nil
  end
  auto_format_callback = _1_
  clear_autocmds({event = "BufWritePre", buffer = get_current_buf(), group = "local-lsp-auto-format"})
  create_autocmd("BufWritePre", {buffer = get_current_buf(), callback = auto_format_callback, group = "local-lsp-auto-format"})
  return nil
end
local function auto_format_on_save(filetypes, extra_opts)
  local callback
  local function _2_()
    return create_auto_format_autocmd(extra_opts)
  end
  callback = _2_
  for _, filetype in ipairs(filetypes) do
    create_autocmd("FileType", {pattern = filetype, callback = callback})
  end
  return nil
end
local function setup(server_name, config)
  return local_plugins_lspconfig.setup(server_name, config)
end
return {["auto-format-on-save"] = auto_format_on_save, setup = setup}
