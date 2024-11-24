-- [nfnl] Compiled from fnl/local/plugins/cmp.fnl by https://github.com/Olical/nfnl, do not edit.
local cmp = require("cmp")
local cm = cmp.mapping
local function _1_(args)
  return vim.fn["vsnip#anonymous"](args.body)
end
return cmp.setup({snippet = {expand = _1_}, mapping = cm.preset.insert({["<C-u>"] = cm.scroll_docs(-4), ["<C-d>"] = cm.scroll_docs(4), ["<C-Space>"] = cm.complete(), ["<CR>"] = cm.confirm({select = false})}), sources = {{name = "nvim_lsp"}, {name = "vsnip"}, {name = "buffer"}}})
