-- [nfnl] Compiled from .nvim.fnl by https://github.com/Olical/nfnl, do not edit.
if not vim.env.PACKER_SYNC then
  local null_ls = require("null-ls")
  local lsp = require("local.lsp")
  null_ls.setup({sources = {null_ls.builtins.formatting.fnlfmt}})
  return lsp["auto-format-on-save"]({"fennel"})
else
  return nil
end