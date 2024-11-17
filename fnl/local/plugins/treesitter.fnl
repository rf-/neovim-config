(local ts (require :nvim-treesitter.configs))

(ts.setup {:ensure_installed :all
           :ignore_install [:haskell :phpdoc]
           :highlight {:enable true}
           :incremental_selection {:enable true}
           :indent {:enable true}})
