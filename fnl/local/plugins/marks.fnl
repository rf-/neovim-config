(local marks (require :marks))
(local {: keymap} vim)
(local {:set map!} keymap)

(marks.setup {})

(map! [:n :v] :<Leader>gm ":MarksListAll<CR>:lcl<CR>:Telescope loclist<CR>"
      {:silent true})
