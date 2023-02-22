(module local.plugins.lspconfig
  {autoload {nvim aniseed.nvim lsp lspconfig cmp-lsp cmp_nvim_lsp}})

(import-macros {:def-autocmd-fn autocmd-fn!
                :def-augroup augroup!} :zest.macros)

; Set LSP shortcuts when client attaches
(defn- on-attach [client buf-nr]
  (when client.server_capabilities.signatureHelpProvider
    (augroup! :lsp-signature-help
              (autocmd-fn! [:CursorHoldI] "*" (vim.lsp.buf.signature_help))))

  ;; We can't use Zest here since these need to be buffer-local
  (each [lhs func-name (pairs {"<C-]>" :definition
                               :<C-p> :hover
                               :<Leader>gtd :type_definition
                               :<Leader>gr :references
                               :<Leader>cr :rename})]
    (vim.api.nvim_buf_set_keymap 0 :n lhs
                                 (.. ":lua vim.lsp.buf." func-name "()<CR>")
                                 {:silent true})))

(local cmp-capabilities (cmp-lsp.default_capabilities))

(lsp.tsserver.setup {:on_attach on-attach :capabilities cmp-capabilities})

(lsp.solargraph.setup {:on_attach on-attach :capabilities cmp-capabilities})

(lsp.rust_analyzer.setup {:on_attach on-attach :capabilities cmp-capabilities})
