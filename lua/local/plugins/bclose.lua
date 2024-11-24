-- [nfnl] Compiled from fnl/local/plugins/bclose.fnl by https://github.com/Olical/nfnl, do not edit.
local g = vim["g"]
local keymap = vim["keymap"]
local map_21 = keymap["set"]
map_21({"n", "v"}, "<Leader>bc", ":Bclose<CR>")
return map_21({"n", "v"}, "<Leader>BC", ":Bclose!<CR>")
