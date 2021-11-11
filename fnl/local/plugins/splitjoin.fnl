(module local.plugins.splitjoin {autoload {nvim aniseed.nvim}})

(import-macros {:def-keymap map!} :zest.macros)

(map! :<Leader>j [n] ":SplitjoinJoin<CR>")
(map! :<Leader>s [n] ":SplitjoinSplit<CR>")
