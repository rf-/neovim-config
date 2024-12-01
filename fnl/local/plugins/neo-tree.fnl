(local {: g : keymap : wait} vim)
(local {:set map!} keymap)
(local neo-tree (require :neo-tree))
(local neo-tree-fs (require :neo-tree.sources.filesystem))
(local neo-tree-renderer (require :neo-tree.ui.renderer))

(map! [:n :v] :<Leader>n ":Neotree toggle<CR>")
(map! [:n :v] :<Leader>N ":Neotree<CR>")
(map! [:n :v] "-" ":Neotree reveal<CR>")

(fn open-dir [state dir-node]
  (neo-tree-fs.toggle_directory state dir-node nil true false)
  ;; See https://github.com/nvim-neo-tree/neo-tree.nvim/issues/701
  (wait 50))

(fn open-all-from-root [state root-node max_depth]
  (local max-depth-reached 1)
  (local stack [root-node])
  (while (not= (next stack) nil)
    (let [node (table.remove stack)
          depth (node:get_depth)
          max-depth-reached (math.max depth max-depth-reached)]
      (when (and (= node.type "directory") (not (node:is_expanded)))
        (open-dir state node))
      (when (or (not max_depth) (< depth (- max_depth 1)))
        (let [children (state.tree:get_nodes (node:get_id))]
          (each [_ v (ipairs children)]
            (table.insert stack v))))))
  max-depth-reached)

(fn open-all-under-cursor [state]
  (open-all-from-root state (state.tree:get_node) 5)
  (neo-tree-renderer.redraw state))

(neo-tree.setup {:default_component_configs {:icon {:folder_closed "▸"
                                                    :folder_open "▾"
                                                    :folder_empty "×"
                                                    :default " "}
                                             :name {:trailing_slash true}
                                             :git_status {:symbols {:added "✚"
                                                                    :modified "∴"
                                                                    :renamed "↔"
                                                                    :untracked "?"
                                                                    :ignored "⊗"
                                                                    :unstaged ""
                                                                    :staged ""
                                                                    :conflict ""}}}
                 :window {:width 32
                          :mappings {:O open-all-under-cursor
                                     :I :toggle_hidden
                                     :/ :noop
                                     "~" :fuzzy_finder}}})
