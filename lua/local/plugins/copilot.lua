-- [nfnl] Compiled from fnl/local/plugins/copilot.fnl by https://github.com/Olical/nfnl, do not edit.
local g = vim["g"]
local copilot_chat = require("CopilotChat")
g.copilot_filetypes = {markdown = false, text = false}
return copilot_chat.setup({})
