(module local.plugins.lspconfig
        {autoload {nvim aniseed.nvim lsp lspconfig cmp-lsp cmp_nvim_lsp}})

; Set LSP shortcuts when client attaches
(defn- on-attach [client buf-nr]
  ;; We can't use Zest here since these need to be buffer-local
  (each [lhs func-name (pairs {"<C-]>" :definition
                               :<C-p> :hover
                               :<Leader>gtd :type_definition
                               :<Leader>gr :references
                               :<Leader>cr :rename})]
    (vim.api.nvim_buf_set_keymap 0 :n lhs
                                 (.. ":lua vim.lsp.buf." func-name "()<CR>")
                                 {:silent true})))

(local cmp-capabilities
       (cmp-lsp.update_capabilities (vim.lsp.protocol.make_client_capabilities)))

(lsp.tsserver.setup {:on_attach on-attach :capabilities cmp-capabilities})

(lsp.solargraph.setup {:on_attach on-attach :capabilities cmp-capabilities})
