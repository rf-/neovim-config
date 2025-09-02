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
  (buf-set-keymap 0 :n :<Leader>gs
                  ":Telescope lsp_dynamic_workspace_symbols<CR>" {:silent true})
  (each [lhs func-name (pairs {"<C-]>" :definition
                               :<C-p> :hover
                               "<C-S-]>" :type_definition
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
  (set vim.o.formatexpr "")
  (set client.server_capabilities.documentFormattingProvider false)
  (on-attach client buf-nr))

(fn on-attach-eslint [client buf-nr]
  (set client.server_capabilities.documentFormattingProvider true)
  (on-attach client buf-nr))

(setup :rust_analyzer
       {:settings {"rust-analyzer" {:workspace {:symbol {:search {:kind :all_symbols}}}}}})

(setup :clangd {:capabilities {:offsetEncoding ["utf-16"]}})

(setup :ts_ls
       {:on_attach on-attach-ts_ls
        :init_options {:hostInfo "neovim" :maxTsServerMemory 8192}})

(setup :eslint {:cmd_env {:NODE_OPTIONS "--max-old-space-size=8192"}
                :on_attach on-attach-eslint})

{: setup}
