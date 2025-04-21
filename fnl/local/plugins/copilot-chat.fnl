(local {: g} vim)
(local copilot-chat (require "CopilotChat"))

(set g.copilot_filetypes {:text false :markdown false})

(copilot-chat.setup {})
