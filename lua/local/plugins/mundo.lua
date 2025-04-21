-- [nfnl] fnl/local/plugins/mundo.fnl
local g = vim["g"]
local keymap = vim["keymap"]
local map_21 = keymap["set"]
g.mundo_right = 1
g.mundo_help = 0
return map_21({"n"}, "<Leader>u", ":MundoToggle<CR>")
