(local lspsaga (require :lspsaga))

(local {: keymap} vim)
(local {:set map!} keymap)

(lspsaga.setup {:symbol_in_winbar {:enable false}
                :lightbulb {:virtual_text false}
                :ui {:code_action "»"}})

(map! [:n :v] :<Leader>go ":Lspsaga outline<CR>")
