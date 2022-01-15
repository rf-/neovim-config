(module local.plugins.nerdcommenter
  {autoload {nvim aniseed.nvim}})

(import-macros {:def-keymap map!} :zest.macros)

(set nvim.g.NERDCreateDefaultMappings false)

(map! :<Leader>/ [nv :remap] :<Plug>NERDCommenterToggle)
