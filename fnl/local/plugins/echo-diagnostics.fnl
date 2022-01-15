(module local.plugins.echo-diagnostics
  {autoload {nvim aniseed.nvim echo-diagnostics echo-diagnostics}})

(import-macros {:def-autocmd-fn autocmd-fn!} :zest.macros)

(echo-diagnostics.setup {:show_diagnostic_number false})

(autocmd-fn! [:CursorHold] "*" (echo-diagnostics.echo_line_diagnostic))
