(local {:nvim_command command :nvim_create_autocmd autocmd} vim.api)
(local {: keys} (require :std.table))

(local ts (require :nvim-treesitter))
(local all-parsers (keys (require :nvim-treesitter.parsers)))

(fn build []
  (: (ts.install all-parsers) :wait 300000)
  (: (ts.update all-parsers) :wait 300000))

; To force rebuild:
; rm -rf ~/.local/share/nvim/site
; (ts.install all-parsers {:force true})

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
