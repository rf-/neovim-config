(module local.plugins.vsnip
  {autoload {nvim aniseed.nvim}})

(set nvim.g.vsnip_snippet_dir (nvim.fn.expand "~/.config/nvim/snippets"))
