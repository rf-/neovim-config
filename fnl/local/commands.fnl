(module local.commands
  {autoload {u local.utils}})

(vim.api.nvim_create_user_command
  :Ag
  (fn [opts]
    (let [results (u.system (.. "ag --nogroup " opts.args))]
      (tset vim.g :__ag_results results)
      (vim.cmd "cexpr g:__ag_results")
      (vim.cmd "copen")))
  {:nargs "*"})
