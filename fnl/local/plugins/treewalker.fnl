(local treewalker (require "treewalker"))
(local nodes (require "treewalker.nodes"))
(local targets (require "treewalker.targets"))
(local operations (require "treewalker.operations"))

(local {:set map!} vim.keymap)

(treewalker.setup {:highlight false})

(fn default-down []
  (let [(target row) (targets.down)]
    (when target [target row])))

(fn next-ancestor-down [node row]
  (if (and node (not= (node:type) "source_file"))
      (let [erow (nodes.get_erow node)]
        (if (> erow row)
            [node erow]
            (next-ancestor-down (node:parent) row)))
      nil))

(fn update-jump-list []
  (vim.cmd "normal! m'"))

(fn move-down []
  (let [node (nodes.get_current)
        current-row (vim.fn.line ".")
        [target row] (or (default-down) (next-ancestor-down node current-row)
                         [nil nil])
        is-neighbor (and row (= row (+ current-row 1)))]
    (when target
      (when (not is-neighbor) (update-jump-list))
      (operations.jump target row)
      (when (not is-neighbor) (update-jump-list)))))

(map! [:n] "[-" ":Treewalker Left<CR>" {:silent true})
(map! [:n] "]-" ":Treewalker Right<CR>" {:silent true})
(map! [:n] "<C-->" ":Treewalker Up<CR>" {:silent true})
(map! [:n] "<C-=>" #(move-down) {:silent true})
(map! [:n] "<C-S-->" ":Treewalker SwapLeft<CR>" {:silent true})
(map! [:n] "<C-S-=>" ":Treewalker SwapRight<CR>" {:silent true})
