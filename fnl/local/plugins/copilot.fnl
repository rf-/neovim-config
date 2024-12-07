(let [copilot (require "copilot")
      copilot-auth (require "copilot.auth")
      (ok? val-or-err) (pcall copilot-auth.get-cred)]
  (if ok?
      ;; If auth is configured, set everything up.
      (do
        (copilot.setup {:suggestion {:auto_trigger true}})
        (let [copilot-chat (require "CopilotChat")]
          (copilot-chat.setup {})))
      ;; Otherwise, just make `:Copilot auth` available.
      (copilot.setup {:filetypes {:* false}})))
