(local tbl (require :std.table))
(local local-plugins-lspconfig (require :local.plugins.lspconfig))
(local {:nvim_create_augroup create-augroup
        :nvim_create_autocmd create-autocmd
        :nvim_clear_autocmds clear-autocmds
        :nvim_get_current_buf get-current-buf} vim.api)

(create-augroup :local-lsp-auto-format {:clear true})

(fn create-auto-format-autocmd [extra-opts]
  (let [merged-options (tbl.merge {:formatting_options {:timeout_ms 5000}}
                                  (or extra-opts {}))
        auto-format-callback (fn [] (vim.lsp.buf.format merged-options) nil)]
    (clear-autocmds {:event :BufWritePre
                     :buffer (get-current-buf)
                     :group :local-lsp-auto-format})
    (create-autocmd :BufWritePre
                    {:buffer (get-current-buf)
                     :callback auto-format-callback
                     :group :local-lsp-auto-format})
    nil))

(fn auto-format-on-save [filetypes extra-opts]
  (let [callback #(create-auto-format-autocmd extra-opts)]
    (each [_ filetype (ipairs filetypes)]
      (create-autocmd :FileType {:pattern filetype :callback callback}))))

(fn setup [server-name config]
  (local-plugins-lspconfig.setup server-name config))

{: auto-format-on-save : setup}
