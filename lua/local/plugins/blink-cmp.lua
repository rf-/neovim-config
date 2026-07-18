-- [nfnl] fnl/local/plugins/blink-cmp.fnl
local blink_cmp = require("blink.cmp")
return blink_cmp.setup({completion = {list = {selection = {auto_insert = true, preselect = false}}, menu = {draw = {gap = 2}}, documentation = {auto_show = true, auto_show_delay_ms = 500}, ghost_text = {enabled = true}}, cmdline = {enabled = true, keymap = {preset = "enter", ["<Tab>"] = {"show", "accept"}, ["<C-k>"] = false}}, keymap = {preset = "enter", ["<C-k>"] = false}, signature = {enabled = true}})
