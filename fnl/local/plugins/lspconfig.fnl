(module local.plugins.lspconfig
  {autoload {nvim aniseed.nvim
             lsp lspconfig
             configs "lspconfig.configs"
             cmp-lsp cmp_nvim_lsp
             tbl std.table}})

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

; Set up servers we pretty much always want when available

(lsp.tsserver.setup {:on_attach on-attach-tsserver :capabilities cmp-capabilities})
(lsp.solargraph.setup {:on_attach on-attach :capabilities cmp-capabilities})
(lsp.rust_analyzer.setup {:on_attach on-attach :capabilities cmp-capabilities})
(lsp.clangd.setup {:on_attach on-attach :capabilities cmp-capabilities})
(lsp.eslint.setup {:on_attach on-attach-eslint :capabilities cmp-capabilities})

; Set up default config for servers we want to opt into
; (defn- configure-server [server-name]
;   (tset configs
;         server-name
;         {:default_config
;          (tbl.merge {} (. (. configs server-name) "default_config")
;                     {:on_attach on-attach :capabilities cmp-capabilities})}))
; 
; (configure-server :tailwindcss)
