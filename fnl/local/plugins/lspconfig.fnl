(local lspconfig (require :lspconfig))
(local cmp-lsp (require :cmp_nvim_lsp))
(local tbl (require :std.table))
(local {:nvim_create_augroup augroup
        :nvim_create_autocmd autocmd
        :nvim_clear_autocmds autocmd!
        :nvim_buf_set_keymap buf-set-keymap} vim.api)

(augroup :lsp-config-signature-help {:clear true})

; Set LSP shortcuts when client attaches
(fn on-attach [client buf-nr]
  (when client.server_capabilities.signatureHelpProvider
    (autocmd! {:event :CursorHoldI
               :buffer buf-nr
               :group :lsp-config-signature-help})
    (autocmd :CursorHoldI
             {:buffer buf-nr
              :callback (fn [] (vim.lsp.buf.signature_help) nil)
              :group :lsp-config-signature-help}))
  (each [lhs func-name (pairs {"<C-]>" :definition
                               :<C-p> :hover
                               :<Leader>gtd :type_definition
                               :<Leader>gr :references
                               :<Leader>cr :rename})]
    (buf-set-keymap 0 :n lhs (.. ":lua vim.lsp.buf." func-name "()<CR>")
                    {:silent true})))

(local cmp-capabilities (cmp-lsp.default_capabilities))

(fn setup [server-name extra-config]
  (let [setup-fn (. (. lspconfig server-name) :setup)
        config (tbl.merge {:on_attach on-attach :capabilities cmp-capabilities}
                          (or extra-config {}))]
    (setup-fn config)))

(fn on-attach-ts_ls [client buf-nr]
  (tset client.server_capabilities :documentFormattingProvider false)
  (on-attach client buf-nr))

(fn on-attach-eslint [client buf-nr]
  (tset client.server_capabilities :documentFormattingProvider true)
  (on-attach client buf-nr))

(setup :solargraph)
(setup :rust_analyzer)
(setup :clangd {:capabilities {:offsetEncoding ["utf-16"]}})
(setup :ts_ls {:on_attach on-attach-ts_ls})
(setup :eslint {:on_attach on-attach-eslint})

{: setup}
