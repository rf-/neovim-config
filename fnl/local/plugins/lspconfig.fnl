(module local.plugins.lspconfig
  {autoload {nvim aniseed.nvim lsp lspconfig cmp-lsp cmp_nvim_lsp}})

(import-macros {:def-autocmd-fn autocmd-fn!
                :def-augroup augroup!} :zest.macros)

(nvim.create_augroup :lsp-config-signature-help {:clear true})

; Set LSP shortcuts when client attaches
(defn- on-attach [client buf-nr]
  (when client.server_capabilities.signatureHelpProvider
    (vim.api.nvim_clear_autocmds
      {:event :CursorHoldI
       :buffer buf-nr
       :group :lsp-config-signature-help})
    (nvim.create_autocmd
      :CursorHoldI
      {:buffer buf-nr
       :callback vim.lsp.buf.signature_help
       :group :lsp-config-signature-help}))

  ;; We can't use Zest here since these need to be buffer-local
  (each [lhs func-name (pairs {"<C-]>" :definition
                               :<C-p> :hover
                               :<Leader>gtd :type_definition
                               :<Leader>gr :references
                               :<Leader>cr :rename})]
    (vim.api.nvim_buf_set_keymap 0 :n lhs
                                 (.. ":lua vim.lsp.buf." func-name "()<CR>")
                                 {:silent true})))

(defn- on-attach-tsserver [client buf-nr]
  (tset client.server_capabilities :documentFormattingProvider false)
  (on-attach client buf-nr))

(defn- on-attach-eslint [client buf-nr]
  (tset client.server_capabilities :documentFormattingProvider true)
  (on-attach client buf-nr))

(local cmp-capabilities (cmp-lsp.default_capabilities))

(lsp.tsserver.setup {:on_attach on-attach-tsserver :capabilities cmp-capabilities})

(lsp.solargraph.setup {:on_attach on-attach :capabilities cmp-capabilities})

(lsp.rust_analyzer.setup {:on_attach on-attach :capabilities cmp-capabilities})

(lsp.clangd.setup {:on_attach on-attach :capabilities cmp-capabilities})

(lsp.tailwindcss.setup {:on_attach on-attach :capabilities cmp-capabilities})

(lsp.eslint.setup {:on_attach on-attach-eslint :capabilities cmp-capabilities})
