(local {: keymap} vim)
(local {:set map!} keymap)

(map! [:n] "[-" ":Treewalker Left<CR>" {:silent true})
(map! [:n] "]-" ":Treewalker Right<CR>" {:silent true})
(map! [:n] "<C-->" ":Treewalker Up<CR>" {:silent true})
(map! [:n] "<C-=>" ":Treewalker Down<CR>" {:silent true})
(map! [:n] "<C-S-->" ":Treewalker SwapLeft<CR>" {:silent true})
(map! [:n] "<C-S-=>" ":Treewalker SwapRight<CR>" {:silent true})
