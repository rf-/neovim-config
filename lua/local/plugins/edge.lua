-- [nfnl] fnl/local/plugins/edge.fnl
local g = vim.g
local command = vim.api.nvim_command
g.edge_style = "aura"
g.edge_enable_italic = 1
command("colorscheme edge")
return command("highlight link LspSignatureActiveParameter DiffAdd")
