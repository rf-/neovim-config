-- [nfnl] Compiled from fnl/local/plugins/treesitter.fnl by https://github.com/Olical/nfnl, do not edit.
local ts = require("nvim-treesitter.configs")
return ts.setup({ensure_installed = "all", ignore_install = {"haskell", "phpdoc"}, highlight = {enable = true}, incremental_selection = {enable = true}, indent = {enable = true}})
