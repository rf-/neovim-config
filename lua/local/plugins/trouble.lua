-- [nfnl] fnl/local/plugins/trouble.fnl
local trouble = require("trouble")
local keymap = vim.keymap
local map_21 = keymap.set
trouble.setup({mode = "document_diagnostics", fold_open = "v", fold_closed = ">", signs = {error = "error", warning = "warn", hint = "hint", information = "info"}, use_diagnostic_signs = true, icons = false, indent_lines = false})
return map_21({"n", "v"}, "<Leader>d", ":TroubleToggle<CR>", {silent = true})
