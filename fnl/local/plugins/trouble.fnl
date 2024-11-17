(local trouble (require :trouble))
(local {: keymap} vim)
(local {:set map!} keymap)

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

(map! [:n :v] :<Leader>d ":TroubleToggle<CR>" {:silent true})
