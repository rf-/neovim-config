(local {: g : keymap} vim)
(local {:set map!} keymap)

(set g.mundo_right 1)
(set g.mundo_help 0)

(map! [:n] :<Leader>u ":MundoToggle<CR>")
