(module local.plugins.telescope
        {autoload {nvim aniseed.nvim
                   std-fn std.functional
                   std-table std.table
                   telescope telescope
                   telescope-action-state telescope.actions.state
                   telescope-actions telescope.actions
                   telescope-builtin telescope.builtin
                   telescope-from-entry telescope.from_entry
                   telescope-themes telescope.themes}})

(local {: map : bind : foldl} std-fn)
(local {: merge} std-table)

(import-macros {:def-keymap-fn map-fn!} :zest.macros)

(defn- entry-to-qf [entry]
  {:bufnr entry.bufnr
   :filename (telescope-from-entry.path entry false)
   :lnum (or entry.lnum 1)
   :col (or entry.col 1)
   :text (or entry.text (if (= (type entry.value) :table) entry.value.text
                            entry.value))})

(defn- map-vals [func tbl]
  (map (fn [_ value]
         (func value)) tbl))

(defn- escape-filename [filename]
  (nvim.fn.escape filename " %#'\""))

(defn- open-one-or-more [cmd qf-or-args prompt-bufnr]
  (let [picker (telescope-action-state.get_current_picker prompt-bufnr)
        multi-selection (picker:get_multi_selection)
        has-multi (> (length multi-selection) 0)
        selection (if has-multi multi-selection [(picker:get_selection)])
        qfs (map-vals entry-to-qf selection)]
    (telescope-actions.close prompt-bufnr)
    (when (> (length qfs) 0)
      (let [qf (. qfs 1)]
        (nvim.command (.. cmd " " (escape-filename qf.filename)))
        (nvim.command (.. "normal! " qf.lnum :G qf.col :|zz))))
    (when (and (> (length qfs) 1) (= qf-or-args :qf))
      (nvim.fn.setqflist qfs)
      (nvim.command :copen)
      (nvim.command "wincmd J")
      (nvim.command "10 wincmd _")
      (nvim.command "wincmd p"))
    (when (and (> (length qfs) 1) (= qf-or-args :args))
      (let [filenames (map-vals (fn [e]
                                  (escape-filename e.filename))
                                qfs)]
        (nvim.command (.. "args " (table.concat filenames " ")))))))

(defn- map-all [mappings]
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
                  :pickers {:buffers {:mappings file-mappings}
                            :find_files {:mappings file-mappings}
                            :lsp_code_actions (merge {:border true} (telescope-themes.get_cursor))
                            :live_grep {:mappings grep-mappings}
                            :grep_string {:mappings grep-mappings}}
                  :extensions {}})

(telescope.load_extension :fzy_native)

(map-fn! :<Leader>a [nv :silent] (telescope-builtin.grep_string))
(map-fn! :<Leader>f [n :silent] (telescope-builtin.live_grep))
(map-fn! :<Leader>k [n :silent] (telescope-builtin.lsp_code_actions))
(map-fn! :<Leader>t [n :silent] (telescope-builtin.buffers))
(map-fn! :<Leader>T [n :silent] (telescope-builtin.find_files))
