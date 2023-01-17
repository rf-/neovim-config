(module local.plugins.cmp
  {autoload {nvim aniseed.nvim cmp cmp}})

(local cm cmp.mapping)

(cmp.setup {:snippet {:expand (fn [args]
                                ((. vim.fn "vsnip#anonymous") args.body))}
            :mapping (cm.preset.insert {:<C-u> (cm.scroll_docs -4)
                                        :<C-d> (cm.scroll_docs 4)
                                        :<C-Space> (cm.complete)
                                        :<CR> (cm.confirm {:select false})})
            :sources [{:name :nvim_lsp} {:name :vsnip} {:name :buffer}]})
