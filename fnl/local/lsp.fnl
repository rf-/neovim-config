(module local.lsp
  {autoload {nvim aniseed.nvim
             tbl std.table
             local-plugins-lspconfig local.plugins.lspconfig}})

(nvim.create_augroup :local-lsp-auto-format {:clear true})

(defn- create-auto-format-autocmd [extra-opts]
  (let [merged-options (tbl.merge
                         {:formatting_options {:timeout_ms 5000}}
                         (or extra-opts {}))
        auto-format-callback (fn [] (vim.lsp.buf.format merged-options))]
    (vim.api.nvim_clear_autocmds
      {:event :BufWritePre
       :buffer (vim.api.nvim_get_current_buf)
       :group :local-lsp-auto-format})
    (nvim.create_autocmd
      :BufWritePre
      {:buffer (vim.api.nvim_get_current_buf)
       :callback auto-format-callback
       :group :local-lsp-auto-format})))

(defn auto-format-on-save [filetypes extra-opts]
  (let [callback (fn [] (create-auto-format-autocmd extra-opts))]
    (each [_ filetype (ipairs filetypes)]
      (nvim.create_autocmd :FileType {:pattern filetype :callback callback}))))

(defn setup [server-name config]
  (local-plugins-lspconfig.setup server-name config))
