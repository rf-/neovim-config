(local {: ex : g} vim)
(local {:nvim_command command} vim.api)

(fn config [name]
  (let [(ok? val-or-err) (pcall require (.. :local.plugins. name))]
    (when (not ok?)
      (print (.. "Error loading plugin config: " val-or-err)))))

(config :neo-tree)
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
(config :trouble)
(config :echo-diagnostics)
(config :lspsaga)

(let [copilot (require "copilot")]
  (copilot.setup {:suggestion {:auto_trigger true}}))

(let [copilot-chat (require "CopilotChat")]
  (copilot-chat.setup {}))

(set g.edge_style :aura)
(set g.edge_enable_italic 1)
(command "colorscheme edge")
