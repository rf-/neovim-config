-- [nfnl] Compiled from fnl/local/plugins/vsnip.fnl by https://github.com/Olical/nfnl, do not edit.
local g = vim["g"]
local command = vim.api["nvim_command"]
g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snippets")
command("imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
return command("smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
