-- [nfnl] Compiled from fnl/local/plugins/nerdcommenter.fnl by https://github.com/Olical/nfnl, do not edit.
local g = vim["g"]
local keymap = vim["keymap"]
local map_21 = keymap["set"]
g.NERDCreateDefaultMappings = false
return map_21({"n", "v"}, "<Leader>/", "<Plug>NERDCommenterToggle")
