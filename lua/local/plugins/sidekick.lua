-- [nfnl] fnl/local/plugins/sidekick.fnl
local sidekick = require("sidekick")
local function setup()
  return sidekick.setup({copilot = {status = {enabled = true, level = vim.log.levels.WARN}}})
end
return {setup = setup}
