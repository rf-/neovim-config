(local null-ls (require :null-ls))
(local local-lsp (require :local.lsp))

(local {: g : o : bo : wo : env : opt : keymap} vim)
(local {:set map!} keymap)
(local {:nvim_command command :nvim_create_autocmd autocmd} vim.api)
(local {:nvim_command command
        :nvim_create_augroup create-augroup
        :nvim_create_autocmd create-autocmd
        :nvim_clear_autocmds clear-autocmds} vim.api)

;; (set o.colorcolumn :100)
;; (set o.textwidth 100)

;; (create-autocmd :FileType {:pattern "cpp" :callback #(set bo.textwidth 99)})

;; (set o.path (.. o.path ",./client/src"))

;; (vim.lsp.set_log_level "debug")

;; (vim.lsp.enable :ts_ls false)
;; (vim.lsp.enable :tsgo)

;; (local-lsp.setup :tailwindcss)

;; (local prettier-source
;;        (null_ls.builtins.formatting.prettier.with {:filetypes [:css
;;                                                                :json
;;                                                                :typescript
;;                                                                :typescriptreact
;;                                                                :javascript
;;                                                                :javascriptreact]}))

(null-ls.setup {:sources [null_ls.builtins.formatting.fnlfmt
                          ;; null_ls.builtins.diagnostics.rubocop
                          ;; prettier-source
                          ]})

(local-lsp.auto-format-on-save [:fennel
                                ;; :ruby
                                ;; :css
                                ;; :json
                                ;; :typescript
                                ;; :typescriptreact
                                ;; :javascript
                                ;; :javascriptreact
                                ]
                               {:name "null-ls"})

;; (local-lsp.auto-format-on-save [:typescript
;;                                 :typescriptreact
;;                                 :javascript
;;                                 :javascriptreact]
;;                                {:name "eslint"})

;; (local-lsp.auto-format-on-save [:rust] {:name "rust_analyzer"})

;; (local-lsp.auto-format-on-save [:cpp :objcpp] {:name "clangd"})

;; (local-lsp.auto-format-on-save [:go :gomod :gowork :gotmpl] {:name "gopls"})

;; (local-lsp.enable-sidekick)
