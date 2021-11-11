(module local.plugins.bclose {autoload {nvim aniseed.nvim}})

(import-macros {:def-keymap map!} :zest.macros)

(map! :<Leader>bc [nv] ":Bclose<CR>")
(map! :<Leader>BC [nv] ":Bclose!<CR>")
