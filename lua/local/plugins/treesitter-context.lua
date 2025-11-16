-- [nfnl] fnl/local/plugins/treesitter-context.fnl
local treesitter_context = require("treesitter-context")
return treesitter_context.setup({multiline_threshold = 1, trim_scope = "inner", mode = "topline", max_lines = 4})
