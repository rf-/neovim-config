(module local.plugins.ale
        {require {_ nvim-ale-diagnostic} autoload {nvim aniseed.nvim}})

(import-macros {:def-keymap map!} :zest.macros)

; Rely on local rc files to enable ALE linters
(set nvim.g.ale_linters_explicit 1)

; If there's a fixer enabled, use it
(set nvim.g.ale_fix_on_save 1)

; There's really no excuse not to have `eslint_d` installed
(set nvim.g.ale_javascript_eslint_executable :eslint_d)

; Disable default LSP diagnostics, since the `nvim-ale-diagnostic` plugin will
; feed them into ALE instead
(tset vim.lsp.handlers :textDocument/publishDiagnostics
      (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
                    {:underline false
                     :virtual_text false
                     :signs true
                     :update_in_insert false}))

; Show full diagnostic in preview window
(map! :<Leader>gd [n :silent] ":ALEDetail<CR>")

; Move between both ALE and LSP diagnostics
(map! "[d" [n :silent] ":ALEPreviousWrap<CR>")
(map! "]d" [n :silent] ":ALENextWrap<CR>")
