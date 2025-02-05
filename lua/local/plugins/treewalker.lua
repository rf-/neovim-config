-- [nfnl] Compiled from fnl/local/plugins/treewalker.fnl by https://github.com/Olical/nfnl, do not edit.
local keymap = vim["keymap"]
local map_21 = keymap["set"]
map_21({"n"}, "[-", ":Treewalker Left<CR>", {silent = true})
map_21({"n"}, "]-", ":Treewalker Right<CR>", {silent = true})
map_21({"n"}, "<C-->", ":Treewalker Up<CR>", {silent = true})
map_21({"n"}, "<C-=>", ":Treewalker Down<CR>", {silent = true})
map_21({"n"}, "<C-S-->", ":Treewalker SwapLeft<CR>", {silent = true})
return map_21({"n"}, "<C-S-=>", ":Treewalker SwapRight<CR>", {silent = true})
