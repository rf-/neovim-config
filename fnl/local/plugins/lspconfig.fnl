(module local.plugins.lspconfig
  {autoload {nvim aniseed.nvim
             view aniseed.view
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

(local cmp-capabilities (cmp-lsp.default_capabilities))

(defn setup [server-name extra-config]
  (let [setup-fn (. (. lsp server-name) :setup)
        config (tbl.merge
                 {:on_attach on-attach :capabilities cmp-capabilities}
                 (or extra-config {}))]
    (setup-fn config)))

(defn- on-attach-tsserver [client buf-nr]
  (tset client.server_capabilities :documentFormattingProvider false)
  (on-attach client buf-nr))

(defn- on-attach-eslint [client buf-nr]
  (tset client.server_capabilities :documentFormattingProvider true)
  (on-attach client buf-nr))

(setup :solargraph)
(setup :rust_analyzer)
(setup :clangd)
(setup :tsserver {:on_attach on-attach-tsserver})
(setup :eslint {:on_attach on-attach-eslint})
