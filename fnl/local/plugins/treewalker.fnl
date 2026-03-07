(local treewalker (require "treewalker"))
(local nodes (require "treewalker.nodes"))
(local targets (require "treewalker.targets"))
(local operations (require "treewalker.operations"))

(local {:set map!} vim.keymap)
(local {:nvim_create_autocmd create-autocmd} vim.api)
(local {:get_parser get-parser} vim.treesitter)

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

(fn create-treewalker-bindings [event]
  (let [{: buf} event
        map!! #(map! [:n] $1 $2 {:silent true :buffer buf})
        parser (get-parser buf nil {:error false})]
    (when parser
      ;; By default, - and = move up and down within just the current scope
      (map!! "-" #(move up-target))
      (map!! "=" #(move down-target))
      ;; Adding Ctrl jumps to lines at the same level across scope boundaries
      (map!! "<C-->" #(move up-or-jump-target))
      (map!! "<C-=>" #(move down-or-jump-target))
      ;; Adding Shift moves to parent or child nodes
      (map!! "_" ":Treewalker Left<CR>")
      (map!! "+" ":Treewalker Right<CR>")
      ;; Adding Ctrl-Shift jumps to the parent level at scope boundaries
      (map!! "<C-_>" #(move up-or-out-target))
      (map!! "<C-+>" #(move down-or-out-target))
      ;; Adding Alt swaps expressions
      (map!! "<A-->" ":Treewalker SwapLeft<CR>")
      (map!! "<A-=>" ":Treewalker SwapRight<CR>")
      ;; Adding Alt-Shift swaps declarations
      (map!! "<A-_>" ":Treewalker SwapUp<CR>")
      (map!! "<A-+>" ":Treewalker SwapDown<CR>"))))

(create-autocmd :FileType {:callback create-treewalker-bindings})
