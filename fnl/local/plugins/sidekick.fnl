(local sidekick (require :sidekick))

(fn setup []
  (sidekick.setup {:copilot {:status {:enabled true :level vim.log.levels.WARN}}}))

{: setup}
