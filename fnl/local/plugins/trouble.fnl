(module local.plugins.trouble
  {autoload {nvim aniseed.nvim trouble trouble}})

(import-macros {:def-keymap map!} :zest.macros)

(trouble.setup {:mode :document_diagnostics
                :icons false
                :fold_open :v
                :fold_closed ">"
                :indent_lines false
                :signs {:error :error
                        :warning :warn
                        :hint :hint
                        :information :info}
                :use_diagnostic_signs true})

(map! :<Leader>d [nv :silent] ":TroubleToggle<CR>")
