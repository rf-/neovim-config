(local {: ex : g} vim)
(local {:nvim_command command} vim.api)

(fn config [name]
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
(config :cmp)
(config :vsnip)
(config :telescope)
(config :nerdtree)
(config :trouble)
(config :echo-diagnostics)

(set g.edge_style :aura)
(set g.edge_enable_italic 1)
(command "colorscheme edge")
