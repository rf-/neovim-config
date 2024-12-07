-- [nfnl] Compiled from fnl/local/plugins/copilot.fnl by https://github.com/Olical/nfnl, do not edit.
local copilot = require("copilot")
local copilot_auth = require("copilot.auth")
local ok_3f, val_or_err = pcall(copilot_auth["get-cred"])
if ok_3f then
  copilot.setup({suggestion = {auto_trigger = true}})
  local copilot_chat = require("CopilotChat")
  return copilot_chat.setup({})
else
  return copilot.setup({filetypes = {["*"] = false}})
end
