(module local.plugins.cmp
  {autoload {nvim aniseed.nvim cmp cmp}})

(local cm cmp.mapping)

(cmp.setup {:snippet {:expand (fn [args]
                                ((. vim.fn "vsnip#anonymous") args.body))}
            :mapping {:<C-u> (cm (cm.scroll_docs -4) [:i :c])
                      :<C-d> (cm (cm.scroll_docs 4) [:i :c])
                      :<C-Space> (cm (cm.complete) [:i :c])
                      ;:<C-e> (cm {:i (cm.abort) :c (cm.close)})
                      :<CR> (cm.confirm {:select false})}
            :sources [{:name :nvim_lsp} {:name :vsnip} {:name :buffer}]})
