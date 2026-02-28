(local treewalker (require "treewalker"))
(local nodes (require "treewalker.nodes"))
(local targets (require "treewalker.targets"))
(local operations (require "treewalker.operations"))

(local {:set map!} vim.keymap)

(treewalker.setup {:highlight false :scope_confined true})

(fn should-confine-vertical-move [current-node candidate]
  (let [current-parent (nodes.scope_parent current-node)
        candidate-anchor (nodes.get_highest_row_coincident candidate)]
    (when (and current-parent candidate-anchor)
      (not (nodes.is_descendant_of current-parent candidate-anchor)))))

(fn up-target [current-node current-row]
  (let [(target row) (targets.up current-node current-row)]
    (if (and target (not (should-confine-vertical-move current-node target)))
        (values target row)
        (values nil nil))))

(fn down-target [current-node current-row]
  (let [(target row) (targets.down current-node current-row)]
    (if (and target (not (should-confine-vertical-move current-node target)))
        (values target row)
        (values nil nil))))

(fn up-or-jump-target [current-node current-row]
  (targets.up current-node current-row))

(fn down-or-jump-target [current-node current-row]
  (targets.down current-node current-row))

(fn up-or-out-target [from-node from-row]
  (let [(prev-node prev-row) (up-target from-node from-row)
        from-srow (nodes.get_srow from-node)
        parent-node (from-node:parent)
        parent-srow (when parent-node (nodes.get_srow parent-node))]
    (if prev-node
        (values prev-node prev-row)
        (if (not= from-row from-srow)
            (values from-node from-srow)
            (if (not= from-row parent-srow)
                (values parent-node parent-srow)
                (up-or-out-target parent-node parent-srow))))))

(fn down-or-out-target [from-node from-row]
  (let [(next-node next-row) (down-target from-node from-row)
        from-erow (nodes.get_erow from-node)
        parent-node (from-node:parent)
        parent-erow (when parent-node (nodes.get_erow parent-node))]
    (if next-node
        (values next-node next-row)
        (if (not= from-row from-erow)
            (values from-node from-erow)
            (if (not= from-row parent-erow)
                (values parent-node parent-erow)
                (down-or-out-target parent-node parent-erow))))))

(fn update-jump-list []
  (vim.cmd "normal! m'"))

(fn move [get-target]
  (let [(current-node current-row) (nodes.get_highest_node_at_current_row)
        (target row) (get-target current-node current-row)]
    (when target
      (let [is-neighbor (nodes.have_neighbor_srow current-node target)]
        (when (not is-neighbor) (update-jump-list))
        (operations.jump target row)
        (when (not is-neighbor) (update-jump-list))))))

; By default, - and = move up and down within just the current scope
(map! [:n] "-" #(move up-target) {:silent true})
(map! [:n] "=" #(move down-target) {:silent true})

; Adding Ctrl jumps to lines at the same level across scope boundaries
(map! [:n] "<C-->" #(move up-or-jump-target) {:silent true})
(map! [:n] "<C-=>" #(move down-or-jump-target) {:silent true})

; Adding Shift moves to parent or child nodes
(map! [:n] "<S-->" ":Treewalker Left<CR>" {:silent true})
(map! [:n] "<S-=>" ":Treewalker Right<CR>" {:silent true})

; Adding Ctrl-Shift jumps to the parent level at scope boundaries
(map! [:n] "<C-S-->" #(move up-or-out-target) {:silent true})
(map! [:n] "<C-S-=>" #(move down-or-out-target) {:silent true})

; Adding Alt swaps expressions
(map! [:n] "<A-->" ":Treewalker SwapLeft<CR>" {:silent true})
(map! [:n] "<A-=>" ":Treewalker SwapRight<CR>" {:silent true})

; Adding Alt-Shift swaps declarations
(map! [:n] "<A-S-->" ":Treewalker SwapUp<CR>" {:silent true})
(map! [:n] "<A-S-=>" ":Treewalker SwapDown<CR>" {:silent true})
