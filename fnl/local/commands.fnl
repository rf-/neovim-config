(local {: g} vim)
(local {:nvim_command command
        :nvim_create_user_command create-command
        :nvim_list_wins list-wins
        :nvim_win_get_config win-get-config
        :nvim_win_close win-close} vim.api)

(local u (require :local.utils))

(fn ag [opts]
  (let [results (u.system (.. "ag --nogroup " opts.args))]
    (set g.__ag_results results)
    (command "cexpr g:__ag_results")
    (command "copen")))

(create-command :Ag ag {:nargs "*" :complete "dir"})

(fn rg [opts]
  (let [results (u.system (.. "rg --no-heading --line-number " opts.args))]
    (set g.__rg_results results)
    (command "cexpr g:__rg_results")
    (command "copen")))

(create-command :Rg rg {:nargs "*" :complete "dir"})

(fn sg [opts]
  (let [results (u.system (.. "sg --heading never --pattern " opts.args))]
    (set g.__sg_results results)
    (command "cexpr g:__sg_results")
    (command "copen")))

(create-command :Sg sg {:nargs "*" :complete "dir"})

(fn close-floating-windows []
  (each [_ win (ipairs (list-wins))]
    (let [config (win-get-config win)]
      (if (not= config.relative "")
          (win-close win false)))))

(create-command :CloseFloatingWindows close-floating-windows {})

(fn bootstrap-config []
  (u.system "cp -n ~/.config/nvim/nfnl.sample.fnl .nfnl.fnl")
  (u.system "cp -n ~/.config/nvim/nvim.sample.fnl .nvim.fnl")
  ((. (require :nfnl.api) "compile-file") {:path ".nvim.fnl"})
  (dofile "./.nvim.lua")
  (vim.cmd.edit ".nvim.fnl"))

(create-command :BootstrapConfig bootstrap-config {})
