-- [nfnl] fnl/local/plugins/bclose.fnl
local g = vim.g
local keymap = vim.keymap
local map_21 = keymap.set
map_21({"n", "v"}, "<Leader>bc", ":Bclose<CR>")
return map_21({"n", "v"}, "<Leader>BC", ":Bclose!<CR>")
