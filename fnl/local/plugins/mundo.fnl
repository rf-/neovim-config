(module local.plugins.mundo {autoload {nvim aniseed.nvim}})

(import-macros {:def-keymap map!} :zest.macros)

(set nvim.g.mundo_right 1)
(set nvim.g.mundo_help 0)

(map! :<Leader>u [n] ":MundoToggle<CR>")
