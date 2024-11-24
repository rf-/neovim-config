-- [nfnl] Compiled from fnl/local/plugins/fugitive.fnl by https://github.com/Olical/nfnl, do not edit.
local keymap = vim["keymap"]
local map_21 = keymap["set"]
map_21({"n"}, "<Leader>gg", ":Git<CR>")
return map_21({"n"}, "<Leader>gb", ":Git blame<CR>")
