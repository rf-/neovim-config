(local {: g : keymap} vim)
(local {:set map!} keymap)

(set g.NERDTreeHijackNetrw :0)

(map! [:n :v] :<Leader>n ":NERDTreeToggle<CR>")
(map! [:n :v] :<Leader>N ":NERDTree<CR>")
(map! [:n :v] "-" ":NERDTreeFind<CR>")
