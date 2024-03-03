(module local.plugins.vsnip
  {autoload {nvim aniseed.nvim}})

(set nvim.g.vsnip_snippet_dir (nvim.fn.expand "~/.config/nvim/snippets"))

(nvim.command "imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
(nvim.command "smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
