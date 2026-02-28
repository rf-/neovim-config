-- [nfnl] fnl/local/plugins/lspconfig.fnl
local lspconfig = require("lspconfig")
local tbl = require("std.table")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local autocmd_21 = vim.api.nvim_clear_autocmds
local buf_set_keymap = vim.api.nvim_buf_set_keymap
augroup("lsp-config-signature-help", {clear = true})
local function wrap_on_attach(name, callback)
  local base_on_attach = vim.lsp.config[name].on_attach
  local function _1_(client, buf_nr)
    if base_on_attach then
      base_on_attach(client, buf_nr)
    else
    end
    if callback then
      callback(client, buf_nr)
    else
    end
    buf_set_keymap(0, "n", "<Leader>gs", ":Telescope lsp_dynamic_workspace_symbols<CR>", {silent = true})
    for lhs, func_name in pairs({["<C-]>"] = "definition", ["<C-p>"] = "hover", ["<C-S-]>"] = "type_definition", ["<Leader>gr"] = "references", ["<Leader>cr"] = "rename"}) do
      buf_set_keymap(0, "n", lhs, (":lua vim.lsp.buf." .. func_name .. "()<CR>"), {silent = true})
    end
    return nil
  end
  return _1_
end
local function setup(server_name, extra_config, opts)
  local extra_config0 = (extra_config or {})
  local on_attach = wrap_on_attach(server_name, extra_config0.on_attach)
  local capabilities = (extra_config0.capabilities or {})
  local config = tbl.merge(tbl.clone(extra_config0), {on_attach = on_attach, capabilities = capabilities})
  vim.lsp.config(server_name, config)
  if not (opts and opts["skip-enable"]) then
    return vim.lsp.enable(server_name)
  else
    return nil
  end
end
local function on_attach_ts(client, buf_nr)
  vim.o.formatexpr = ""
  client.server_capabilities.documentFormattingProvider = false
  return nil
end
local function on_attach_eslint(client, buf_nr)
  client.server_capabilities.documentFormattingProvider = true
  return nil
end
setup("rust_analyzer", {settings = {["rust-analyzer"] = {workspace = {symbol = {search = {kind = "all_symbols"}}}}}})
setup("clangd", {capabilities = {offsetEncoding = {"utf-16"}}})
setup("ts_ls", {on_attach = on_attach_ts, init_options = {hostInfo = "neovim", maxTsServerMemory = 8192}})
setup("tsgo", {on_attach = on_attach_ts, capabilities = {general = {positionEncodings = {"utf-16"}}}}, {["skip-enable"] = true})
setup("eslint", {on_attach = on_attach_eslint, cmd_env = {NODE_OPTIONS = "--max-old-space-size=8192"}})
setup("gopls", {settings = {gopls = {buildFlags = {"-mod=readonly"}}}})
return {setup = setup}
