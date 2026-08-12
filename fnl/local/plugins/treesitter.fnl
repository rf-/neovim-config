(local {:nvim_command command
        :nvim_create_autocmd autocmd
        :nvim_create_user_command create-command} vim.api)

(local {: keys} (require :std.table))

(local ts (require :nvim-treesitter))
(local all-parsers (keys (require :nvim-treesitter.parsers)))

(local u (require :local.utils))

(fn task? [x]
  (and (= (type x) :table) (= (type x.await) :function)))

(fn without-message-prompts [f]
  (let [saved-more vim.o.more
        saved-messagesopt vim.o.messagesopt]
    (set vim.o.more false)
    (set vim.o.messagesopt "wait:0,history:500,progress:c")
    (let [restore (fn []
                    (set vim.o.more saved-more)
                    (set vim.o.messagesopt saved-messagesopt))
          (ok? result) (pcall f)]
      (when (not ok?)
        (restore)
        (error result))
      (if (task? result)
          (result:await #(vim.schedule restore))
          (restore))
      result)))

(fn build []
  (without-message-prompts (fn []
                             (: (ts.install all-parsers) :wait 300000)
                             (: (ts.update all-parsers) :wait 300000))))

(fn rebuild-all []
  (u.system "rm -rf ~/.local/share/nvim/site")
  (without-message-prompts #(ts.install all-parsers {:force true})))

(create-command :TSRebuildAll rebuild-all {})

;; Adapted from https://github.com/nvim-treesitter/nvim-treesitter/discussions/7894
(fn config []
  (local filetype-set {})
  (each [_ parser (ipairs all-parsers)]
    (each [_ filetype (ipairs (vim.treesitter.language.get_filetypes parser))]
      (tset filetype-set filetype true)))
  (autocmd "FileType"
           {:pattern (keys filetype-set)
            :callback (fn []
                        (vim.treesitter.start)
                        (set vim.wo.foldexpr "v:lua.vim.treesitter.foldexpr()")
                        (set vim.bo.indentexpr
                             "v:lua.require'nvim-treesitter'.indentexpr()"))}))

{: build : config}
