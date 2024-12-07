(local {: map : bind : foldl} (require :std.functional))
(local {: merge} (require :std.table))
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
