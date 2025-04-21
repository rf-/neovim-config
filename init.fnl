; Optimize Lua loading
(vim.loader.enable)

(local {: g : env : fs} vim)
(local {:nvim_command command} vim.api)
(local {: stdpath : empty : glob} vim.fn)
(local {: format} string)

(fn bootstrap-lazy []
  (local lazypath (.. (vim.fn.stdpath "data") "/lazy/lazy.nvim"))
  (when (not (vim.uv.fs_stat lazypath))
    (local lazyrepo "https://github.com/folke/lazy.nvim.git")
    (local out (vim.fn.system ["git"
                               "clone"
                               "--filter=blob:none"
                               "--branch=stable"
                               lazyrepo
                               lazypath]))
    (when (not= vim.v.shell_error 0)
      (vim.api.nvim_echo [["Failed to clone lazy.nvim:\n" "ErrorMsg"]
                          [out]
                          ["\nPress any key to exit..."]]
                         true {})
      (vim.fn.getchar)
      (os.exit 1)))
  (vim.opt.rtp:prepend lazypath)
  (require :lazy))

;; fnlfmt: skip
(fn plugin-specs []
  (fn use [name opts]
    (let [opts (or opts {})]
      (tset opts 1 name)
      opts))

  [
    ; Basic Packer/Fennel/Lua setup

    (use "wbthomason/packer.nvim")
    (use "nvim-lua/plenary.nvim")
    (use "Olical/nfnl")
    (use "Olical/conjure")

    ; Ergonomics

    (use "godlygeek/tabular")
    (use "justinmk/vim-sneak")
    (use "tpope/vim-endwise")
    (use "tpope/vim-repeat")
    (use "tpope/vim-speeddating")
    (use "tpope/vim-surround")
    (use "tpope/vim-unimpaired")

    (use "kana/vim-textobj-user")
    (use "glts/vim-textobj-comment"
         {:dependencies ["kana/vim-textobj-user"]})

    (use "preservim/nerdcommenter")

    (use "tpope/vim-fugitive")
    (use "tpope/vim-rhubarb")

    (use "airblade/vim-gitgutter")

    (use "rf-/vim-bclose")

    (use "AndrewRadev/splitjoin.vim")

    (use "simnalamburt/vim-mundo")

    ; Snippets

    (use "hrsh7th/vim-vsnip")

    (use "github/copilot.vim")
    (use "CopilotC-Nvim/CopilotChat.nvim" {:branch "main"})

    ; Language support

    (use "sheerun/vim-polyglot"
        {:init #(set g.polyglot_disabled ["typescript"])})

    (use "rf-/yats.vim")
    (use "nvim-treesitter/nvim-treesitter")

    (use "neovim/nvim-lspconfig")
    (use "nvimtools/none-ls.nvim")
    (use "nvimdev/lspsaga.nvim")

    (use "antosha417/nvim-lsp-file-operations"
         {:dependencies ["nvim-neo-tree/neo-tree.nvim"]})

    (use "folke/trouble.nvim" {:version "v2.10.0"})
    (use "seblj/nvim-echo-diagnostics")

    (use "hrsh7th/cmp-nvim-lsp")
    (use "hrsh7th/cmp-buffer")
    (use "hrsh7th/cmp-path")
    (use "hrsh7th/cmp-cmdline")
    (use "hrsh7th/cmp-vsnip")
    (use "hrsh7th/nvim-cmp")

    (use "vale1410/vim-minizinc")
    (use "nelstrom/vim-textobj-rubyblock"
         {:dependencies ["kana/vim-textobj-user"]})

    (use "iamcco/markdown-preview.nvim"
         {:build "cd app && env COREPACK_ENABLE_AUTO_PIN=0 yarn install"})

    ; Navigation

    (use "nvim-telescope/telescope.nvim")
    (use "nvim-telescope/telescope-fzy-native.nvim")
    (use "nvim-telescope/telescope-ui-select.nvim")

    (use "nvim-neo-tree/neo-tree.nvim"
         {:branch "v3.x" :dependencies ["MunifTanjim/nui.nvim"]})

    (use "aaronik/treewalker.nvim")

    ; Color

    (use "rf-/edge")
  ])

(fn init []
  (local lazy (bootstrap-lazy))
  (require :local.core)
  (lazy.setup {:spec (plugin-specs) :checker {:enabled true}})
  ;; Fix some plugin breaking load path
  (set package.path (.. (fs.normalize "~") "/.config/nvim/lua/?.lua,"
                        package.path))
  (require :local.plugins)
  (require :local.commands))

(if (not g.vscode) (init))
