-- [nfnl] fnl/local/plugins/lspsaga.fnl
local lspsaga = require("lspsaga")
local keymap = vim.keymap
local map_21 = keymap.set
lspsaga.setup({symbol_in_winbar = {enable = false}, lightbulb = {enable = false}})
return map_21({"n", "v"}, "<Leader>go", ":Lspsaga outline<CR>")
