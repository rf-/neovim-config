-- [nfnl] fnl/local/plugins/splitjoin.fnl
local keymap = vim.keymap
local map_21 = keymap.set
map_21({"n"}, "<Leader>j", ":SplitjoinJoin<CR>")
return map_21({"n"}, "<Leader>s", ":SplitjoinSplit<CR>")
