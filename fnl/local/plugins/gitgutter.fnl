(module local.plugins.gitgutter
  {autoload {nvim aniseed.nvim}})

(import-macros {:def-keymap map!} :zest.macros)

(map! "[g" [n] ":GitGutterPrevHunk<CR>")
(map! "]g" [n] ":GitGutterNextHunk<CR>")
