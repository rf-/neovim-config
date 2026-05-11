-- [nfnl] fnl/local/plugins/marks.fnl
local marks = require("marks")
local keymap = vim.keymap
local map_21 = keymap.set
marks.setup({})
return map_21({"n", "v"}, "<Leader>gm", ":MarksListAll<CR>:lcl<CR>:Telescope loclist<CR>", {silent = true})
