(module local.plugins.aniseed
  {autoload {core aniseed.core nvim aniseed.nvim}})

(set nvim.g.conjure#filetypes
     (core.remove (fn [item] (or (= item "rust") (= item "lua"))) nvim.g.conjure#filetypes))
