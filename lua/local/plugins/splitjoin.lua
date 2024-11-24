-- [nfnl] Compiled from fnl/local/plugins/splitjoin.fnl by https://github.com/Olical/nfnl, do not edit.
local keymap = vim["keymap"]
local map_21 = keymap["set"]
map_21({"n"}, "<Leader>j", ":SplitjoinJoin<CR>")
return map_21({"n"}, "<Leader>s", ":SplitjoinSplit<CR>")
