-- [nfnl] fnl/local/plugins/copilot-chat.fnl
local g = vim["g"]
local copilot_chat = require("CopilotChat")
g.copilot_filetypes = {markdown = false, text = false}
return copilot_chat.setup({})
