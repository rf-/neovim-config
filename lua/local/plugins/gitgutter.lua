-- [nfnl] Compiled from fnl/local/plugins/gitgutter.fnl by https://github.com/Olical/nfnl, do not edit.
local keymap = vim["keymap"]
local map_21 = keymap["set"]
map_21({"n"}, "[g", ":GitGutterPrevHunk<CR>")
return map_21({"n"}, "]g", ":GitGutterNextHunk<CR>")
