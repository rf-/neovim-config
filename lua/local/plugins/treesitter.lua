-- [nfnl] fnl/local/plugins/treesitter.fnl
local ts = require("nvim-treesitter.configs")
return ts.setup({ignore_install = {"haskell", "phpdoc"}, highlight = {enable = true}, incremental_selection = {enable = true}, indent = {enable = true}})
