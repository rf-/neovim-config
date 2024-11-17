(local {: g : keymap} vim)
(local {:set map!} keymap)

(map! [:n :v] :<Leader>bc ":Bclose<CR>")
(map! [:n :v] :<Leader>BC ":Bclose!<CR>")
