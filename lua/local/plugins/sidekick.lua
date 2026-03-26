-- [nfnl] fnl/local/plugins/sidekick.fnl
local sidekick = require("sidekick")
return sidekick.setup({copilot = {status = {enabled = true, level = vim.log.levels.WARN}}})
