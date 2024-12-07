; Based on https://github.com/Olical/dotfiles

; Optimize Lua loading
(vim.loader.enable)

(local {: g : env : fs} vim)
(local {:nvim_command command} vim.api)
(local {: stdpath : empty : glob} vim.fn)
(local {: format} string)

(fn init []
  (local pack-path (.. (stdpath "data") "/site/pack"))

  (fn ensure [user repo]
    (let [install-path (format "%s/packer/start/%s" pack-path repo)]
      (if (> (empty (glob install-path)) 0)
        (command (format "!git clone https://github.com/%s/%s %s" user repo install-path))
        (command (format "packadd %s" repo)))))

  (ensure "wbthomason" "packer.nvim")

  (local packer (require "packer"))

  (fn use [name opts]
    (let [opts (or opts {})]
      (tset opts 1 name)
      (packer.use opts)))

  (packer.startup
    (fn []
      ; Basic Packer/Fennel/Lua setup

      (use "wbthomason/packer.nvim")
      (use "nvim-lua/plenary.nvim")
      (use "Olical/nfnl")

      ; Ergonomics

      (use "godlygeek/tabular")
      (use "jeetsukumaran/vim-indentwise")
      (use "justinmk/vim-sneak")
      (use "tpope/vim-endwise")
      (use "tpope/vim-repeat")
      (use "tpope/vim-speeddating")
      (use "tpope/vim-surround")
      (use "tpope/vim-unimpaired")

      (use "kana/vim-textobj-user")
      (use "glts/vim-textobj-comment")

      (use "preservim/nerdcommenter")

      (use "tpope/vim-fugitive")
      (use "tpope/vim-rhubarb")

      (use "airblade/vim-gitgutter")

      (use "rf-/vim-bclose")

      (use "AndrewRadev/splitjoin.vim")

      (use "simnalamburt/vim-mundo")

      ; Snippets

      (use "hrsh7th/vim-vsnip")

      (use "zbirenbaum/copilot.lua")
      (use "CopilotC-Nvim/CopilotChat.nvim")

      ; Language support

      (set g.polyglot_disabled ["typescript"])
      (use "sheerun/vim-polyglot")

      (use "rf-/yats.vim")
      (use "nvim-treesitter/nvim-treesitter")

      (use "neovim/nvim-lspconfig")
      (use "nvimtools/none-ls.nvim")
      (use "nvimdev/lspsaga.nvim")

      (use "antosha417/nvim-lsp-file-operations"
        {:requires ["nvim-neo-tree/neo-tree.nvim"]
         :config #((. (require "lsp-file-operations") :setup))})

      (use "folke/trouble.nvim" {:tag "v2.10.0"})
      (use "seblj/nvim-echo-diagnostics")

      (use "hrsh7th/cmp-nvim-lsp")
      (use "hrsh7th/cmp-buffer")
      (use "hrsh7th/cmp-path")
      (use "hrsh7th/cmp-cmdline")
      (use "hrsh7th/cmp-vsnip")
      (use "hrsh7th/nvim-cmp")

      (use "vale1410/vim-minizinc")
      (use "nelstrom/vim-textobj-rubyblock")

      (use "iamcco/markdown-preview.nvim" {:run "cd app && yarn install"})

      ; Navigation

      (use "nvim-telescope/telescope.nvim")
      (use "nvim-telescope/telescope-fzy-native.nvim")
      (use "nvim-telescope/telescope-ui-select.nvim")

      (use "nvim-neo-tree/neo-tree.nvim"
           {:branch "v3.x" :requires ["MunifTanjim/nui.nvim"]})

      ; Color

      (use "rf-/edge")))

  ; Fix Packer or whatever breaking load path
  (set package.path (.. (fs.normalize "~") "/.config/nvim/lua/?.lua," package.path))

  (when (not env.PACKER_SYNC)
    (require "local.core")
    (require "local.plugins")
    (require "local.commands")))

(if (not g.vscode) (init))
