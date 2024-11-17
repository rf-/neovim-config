(local {: keymap} vim)
(local {:set map!} keymap)

(map! [:n] :<Leader>gg ":Git<CR>")
(map! [:n] :<Leader>gb ":Git blame<CR>")
