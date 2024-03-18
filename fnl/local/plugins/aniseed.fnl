(module local.plugins.aniseed
  {autoload {core aniseed.core nvim aniseed.nvim}})

(set nvim.g.conjure#filetypes
     (core.remove (fn [item] (= item "rust")) nvim.g.conjure#filetypes))
