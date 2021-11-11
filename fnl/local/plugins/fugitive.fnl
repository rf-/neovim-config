(module local.plugins.fugitive {autoload {nvim aniseed.nvim}})

(import-macros {:def-keymap map!} :zest.macros)

(map! :<Leader>gg [n] ":Git<CR>")
(map! :<Leader>gb [n] ":Git blame<CR>")
