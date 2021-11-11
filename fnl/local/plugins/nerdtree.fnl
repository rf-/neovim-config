(module local.plugins.nerdtree {autoload {nvim aniseed.nvim}})

(import-macros {:def-keymap map!} :zest.macros)

(set nvim.g.NERDTreeHijackNetrw :0)

(map! :<Leader>n [nv] ":NERDTreeToggle<CR>")
(map! :<Leader>N [nv] ":NERDTree<CR>")
(map! "-" [nv] ":NERDTreeFind<CR>")
