(local {: map : bind : foldl} (require :std.functional))
(local {: merge : sort} (require :std.table))
(local telescope (require :telescope))
(local telescope-action-state (require :telescope.actions.state))
(local telescope-actions (require :telescope.actions))
(local telescope-builtin (require :telescope.builtin))
(local telescope-from-entry (require :telescope.from_entry))
(local telescope-themes (require :telescope.themes))

(local {: keymap} vim)
(local {:set map!} keymap)
(local {:nvim_command command} vim.api)

(fn entry-to-qf [entry]
  {:bufnr entry.bufnr
   :filename (telescope-from-entry.path entry false)
   :lnum (or entry.lnum 1)
   :col (or entry.col 1)
   :text (or entry.text (if (= (type entry.value) :table) entry.value.text
                            entry.value))})

(fn map-vals [func tbl]
  (map #(func $2) tbl))

(fn escape-filename [filename]
  (vim.fn.escape filename " %#'\""))

(fn open-one-or-more [cmd qf-or-args prompt-bufnr]
  (let [picker (telescope-action-state.get_current_picker prompt-bufnr)
        multi-selection (picker:get_multi_selection)
        has-multi (> (length multi-selection) 0)
        selection (if has-multi multi-selection [(picker:get_selection)])
        qfs (map-vals entry-to-qf selection)]
    (telescope-actions.close prompt-bufnr)
    (when (> (length qfs) 0)
      (let [qf (. qfs 1)]
        (command (.. cmd " " (escape-filename qf.filename)))
        (command (.. "normal! " qf.lnum :G qf.col :|zz))))
    (when (and (> (length qfs) 1) (= qf-or-args :qf))
      (vim.fn.setqflist qfs)
      (command :copen)
      (command "wincmd J")
      (command "10 wincmd _")
      (command "wincmd p"))
    (when (and (> (length qfs) 1) (= qf-or-args :args))
      (let [filenames (map-vals #(escape-filename $.filename) qfs)]
        (command (.. "args " (table.concat filenames " ")))))))

(fn map-all [mappings]
  {:i mappings :n mappings})

(local grep-mappings
       (map-all {:<Enter> (bind open-one-or-more [:edit :qf])
                 :<C-s> (bind open-one-or-more [:split :qf])
                 :<C-v> (bind open-one-or-more [:vsplit :qf])}))

(local file-mappings
       (map-all {:<Enter> (bind open-one-or-more [:edit :args])
                 :<C-s> (bind open-one-or-more [:split :args])
                 :<C-v> (bind open-one-or-more [:vsplit :args])}))

(telescope.setup {:defaults {:winblend 5
                             :border false
                             :path_display [:truncate]
                             :layout_strategy :bottom_pane
                             :layout_config {:bottom_pane {:height 15
                                                           :prompt_position :bottom}}
                             :mappings (map-all {:<C-a> telescope-actions.select_all
                                                 :<C-d> telescope-actions.drop_all
                                                 :<Tab> (+ telescope-actions.toggle_selection
                                                           telescope-actions.move_selection_better)
                                                 :<S-Tab> (+ telescope-actions.toggle_selection
                                                             telescope-actions.move_selection_worse)})}
                  :pickers {:buffers {:mappings file-mappings
                                      :sort_lastused true}
                            :find_files {:mappings file-mappings}
                            :lsp_code_actions (merge {:border true}
                                                     (telescope-themes.get_cursor))
                            :live_grep {:mappings grep-mappings}
                            :grep_string {:mappings grep-mappings}}
                  :extensions {:ui-select (merge {:border true}
                                                 (telescope-themes.get_cursor))}})

(telescope.load_extension :fzy_native)
(telescope.load_extension :ui-select)

(map! [:n :v] :<Leader>a telescope-builtin.grep_string {:silent true})
(map! [:n] :<Leader>f telescope-builtin.live_grep {:silent true})
(map! [:n] :<Leader>k vim.lsp.buf.code_action {:silent true})
(map! [:n] :<Leader>t telescope-builtin.buffers {:silent true})
(map! [:n] :<Leader>T telescope-builtin.find_files {:silent true})

;; Prioritize code actions by server. This has to go here to make sure we're
;; wrapping the Telescope `vim.ui.select` and not the native one.

(local priorities-by-name {:ts_ls 1 :null-ls 2})

(fn get-priorities-by-client-id []
  (let [clients (vim.lsp.get_clients)]
    (collect [_ client (ipairs clients)]
      (values client.id (. priorities-by-name client.name)))))

(fn stable-sort [tbl f]
  (let [with-indices (icollect [i v (ipairs tbl)] [i v])
        sorted-with-indices (sort with-indices
                                  (fn [[i1 v1] [i2 v2]]
                                    (let [result (f v1 v2)]
                                      (if (= result nil)
                                          (< i1 i2)
                                          result))))]
    (map (fn [_ [i v]] v) sorted-with-indices)))

(fn sort-codeactions [items]
  (let [priorities (get-priorities-by-client-id)]
    (stable-sort items (fn [a1 a2]
                         (let [p1 (or (. priorities a1.ctx.client_id) .inf)
                               p2 (or (. priorities a2.ctx.client_id) .inf)]
                           (when (not= p1 p2)
                             (< p1 p2)))))))

(let [select vim.ui.select]
  (set vim.ui.select (fn [items opts on-choice]
                       (if (= opts.kind :codeaction)
                           (select (sort-codeactions items) opts on-choice)
                           (select items opts on-choice)))))
