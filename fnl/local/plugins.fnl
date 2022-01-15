(module local.plugins
  {autoload {nvim aniseed.nvim a aniseed.core packer packer}})

(local {: use : use_rocks} packer)

(defn config [name]
  (let [(ok? val-or-err) (pcall require (.. :local.plugins. name))]
    (when (not ok?)
      (print (.. "Error loading plugin config: " val-or-err)))))

(config :nerdcommenter)
(config :fugitive)
(config :gitgutter)
(config :bclose)
(config :splitjoin)
(config :mundo)
(config :treesitter)
(config :lspconfig)
(config :ale)
(config :cmp)
(config :vsnip)
(config :telescope)
(config :nerdtree)

(set nvim.g.edge_style :aura)
(set nvim.g.edge_enable_italic 1)
(nvim.ex.colorscheme :edge)
