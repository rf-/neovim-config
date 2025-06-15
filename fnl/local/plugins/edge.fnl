(local {: g} vim)
(local {:nvim_command command} vim.api)

(set g.edge_style :aura)
(set g.edge_enable_italic 1)
(command "colorscheme edge")

; Fix overly-aggressive highlighting in signature help
(command "highlight link LspSignatureActiveParameter DiffAdd")
