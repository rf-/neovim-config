-- [nfnl] fnl/local/plugins/gitgutter.fnl
local keymap = vim["keymap"]
local map_21 = keymap["set"]
map_21({"n"}, "[g", ":GitGutterPrevHunk<CR>")
return map_21({"n"}, "]g", ":GitGutterNextHunk<CR>")
