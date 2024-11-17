(local {: g} vim)
(local {:nvim_command command} vim.api)

(set g.vsnip_snippet_dir (vim.fn.expand "~/.config/nvim/snippets"))

(command "imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
(command "smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
