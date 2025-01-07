(local {: g} vim)
(local {:nvim_command command :nvim_create_user_command create-command} vim.api)
(local u (require :local.utils))

(create-command :Rg (fn [opts]
                      (let [results (u.system (.. "rg --no-heading --line-number "
                                                  opts.args))]
                        (set g.__rg_results results)
                        (command "cexpr g:__rg_results")
                        (command "copen")))
                {:nargs "*" :complete "dir"})

(create-command :Sg (fn [opts]
                      (let [results (u.system (.. "sg --heading never --pattern "
                                                  opts.args))]
                        (set g.__sg_results results)
                        (command "cexpr g:__sg_results")
                        (command "copen")))
                {:nargs "*" :complete "dir"})
