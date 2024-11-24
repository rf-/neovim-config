-- [nfnl] Compiled from fnl/local/plugins/nerdtree.fnl by https://github.com/Olical/nfnl, do not edit.
local g = vim["g"]
local keymap = vim["keymap"]
local map_21 = keymap["set"]
g.NERDTreeHijackNetrw = "0"
map_21({"n", "v"}, "<Leader>n", ":NERDTreeToggle<CR>")
map_21({"n", "v"}, "<Leader>N", ":NERDTree<CR>")
return map_21({"n", "v"}, "-", ":NERDTreeFind<CR>")
