(local {: g} vim)
(local {:nvim_command command :nvim_create_user_command create-command} vim.api)
(local u (require :local.utils))

(create-command :Ag (fn [opts]
                      (let [results (u.system (.. "ag --nogroup " opts.args))]
                        (set g.__ag_results results)
                        (command "cexpr g:__ag_results")
                        (command "copen")))
                {:nargs "*" :complete "dir"})

(create-command :Sg (fn [opts]
                      (let [results (u.system (.. "sg --heading never --pattern "
                                                  opts.args))]
                        (set g.__sg_results results)
                        (command "cexpr g:__sg_results")
                        (command "copen")))
                {:nargs "*" :complete "dir"})
