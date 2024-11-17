(local {: keymap} vim)
(local {:set map!} keymap)

(map! [:n] "[g" ":GitGutterPrevHunk<CR>")
(map! [:n] "]g" ":GitGutterNextHunk<CR>")
