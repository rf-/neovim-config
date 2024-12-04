(local lspsaga (require :lspsaga))

(local {: keymap} vim)
(local {:set map!} keymap)

(lspsaga.setup {:symbol_in_winbar {:enable false} :lightbulb {:enable false}})

(map! [:n :v] :<Leader>go ":Lspsaga outline<CR>")
