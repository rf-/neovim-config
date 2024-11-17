(local echo-diagnostics (require :echo-diagnostics))
(local {:nvim_create_autocmd autocmd} vim.api)

(echo-diagnostics.setup {:show_diagnostic_number false})

(autocmd :CursorHold {:pattern "*"
                      :callback (fn [] (echo-diagnostics.echo_line_diagnostic)
                                  nil)})
