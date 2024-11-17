(local {: keymap} vim)
(local {:set map!} keymap)

(map! [:n] :<Leader>j ":SplitjoinJoin<CR>")
(map! [:n] :<Leader>s ":SplitjoinSplit<CR>")
