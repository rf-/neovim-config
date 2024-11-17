(local {: g : keymap} vim)
(local {:set map!} keymap)

(set g.NERDCreateDefaultMappings false)

(map! [:n :v] :<Leader>/ :<Plug>NERDCommenterToggle)
