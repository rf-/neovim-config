-- [nfnl] fnl/local/plugins/lspconfig.fnl
local lspconfig = require("lspconfig")
local cmp_lsp = require("cmp_nvim_lsp")
local tbl = require("std.table")
local augroup = vim.api["nvim_create_augroup"]
local autocmd = vim.api["nvim_create_autocmd"]
local autocmd_21 = vim.api["nvim_clear_autocmds"]
local buf_set_keymap = vim.api["nvim_buf_set_keymap"]
augroup("lsp-config-signature-help", {clear = true})
local function on_attach(client, buf_nr)
  buf_set_keymap(0, "n", "<Leader>gs", ":Telescope lsp_dynamic_workspace_symbols<CR>", {silent = true})
  for lhs, func_name in pairs({["<C-]>"] = "definition", ["<C-p>"] = "hover", ["<C-S-]>"] = "type_definition", ["<Leader>gr"] = "references", ["<Leader>cr"] = "rename"}) do
    buf_set_keymap(0, "n", lhs, (":lua vim.lsp.buf." .. func_name .. "()<CR>"), {silent = true})
  end
  return nil
end
local cmp_capabilities = cmp_lsp.default_capabilities()
local function setup(server_name, extra_config)
  local setup_fn = lspconfig[server_name].setup
  local config = tbl.merge({on_attach = on_attach, capabilities = cmp_capabilities}, (extra_config or {}))
  return setup_fn(config)
end
local function on_attach_ts_ls(client, buf_nr)
  vim.o.formatexpr = ""
  client.server_capabilities.documentFormattingProvider = false
  return on_attach(client, buf_nr)
end
local function on_attach_eslint(client, buf_nr)
  client.server_capabilities.documentFormattingProvider = true
  return on_attach(client, buf_nr)
end
setup("solargraph")
setup("rust_analyzer", {settings = {["rust-analyzer"] = {workspace = {symbol = {search = {kind = "all_symbols"}}}}}})
setup("clangd", {capabilities = {offsetEncoding = {"utf-16"}}})
setup("ts_ls", {on_attach = on_attach_ts_ls, init_options = {hostInfo = "neovim", maxTsServerMemory = 8192}})
setup("eslint", {cmd_env = {NODE_OPTIONS = "--max-old-space-size=8192"}, on_attach = on_attach_eslint})
return {setup = setup}
