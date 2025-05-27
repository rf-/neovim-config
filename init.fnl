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
    ; Basic Fennel/Lua setup

    (use "nvim-lua/plenary.nvim")
    (use "Olical/nfnl"
         {:init #(require :local.plugins.nfnl)})
    (use "Olical/conjure"
         {:init #(require :local.plugins.conjure)})

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

    (use "preservim/nerdcommenter"
         {:init #(require :local.plugins.nerdcommenter)})

    (use "tpope/vim-fugitive"
         {:config #(require :local.plugins.fugitive)})
    (use "tpope/vim-rhubarb")

    (use "airblade/vim-gitgutter"
         {:config #(require :local.plugins.gitgutter)})

    (use "rf-/vim-bclose"
         {:config #(require :local.plugins.bclose)})

    (use "AndrewRadev/splitjoin.vim"
         {:config #(require :local.plugins.splitjoin)})

    (use "simnalamburt/vim-mundo"
         {:init #(require :local.plugins.mundo)})

    ; Snippets

    (use "hrsh7th/vim-vsnip"
         {:init #(require :local.plugins.vsnip)})

    (use "github/copilot.vim")
    (use "CopilotC-Nvim/CopilotChat.nvim"
         {:branch "main"
          :config #(require :local.plugins.copilot-chat)})

    ; Language support

    (use "sheerun/vim-polyglot"
        {:init #(require :local.plugins.polyglot)})

    (use "rf-/yats.vim")

    (use "nvim-treesitter/nvim-treesitter"
         {:branch "main"
          :build #(: (require :local.plugins.treesitter) :build)
          :config #(: (require :local.plugins.treesitter) :config)})

    (use "neovim/nvim-lspconfig"
         {:config #(require :local.plugins.lspconfig)
          :dependencies ["hrsh7th/cmp-nvim-lsp"]})

    (use "nvimtools/none-ls.nvim")

    (use "nvimdev/lspsaga.nvim"
         {:config #(require :local.plugins.lspsaga)})

    (use "antosha417/nvim-lsp-file-operations"
         {:config #(require :local.plugins.lsp-file-operations)
          :dependencies ["nvim-lua/plenary.nvim"
                         "nvim-neo-tree/neo-tree.nvim"]})

    (use "folke/trouble.nvim"
         {:config #(require :local.plugins.trouble)
          :version "v2.10.0"})

    (use "seblj/nvim-echo-diagnostics"
         {:config #(require :local.plugins.echo-diagnostics)})

    (use "hrsh7th/nvim-cmp"
         {:config #(require :local.plugins.cmp)
          :dependencies ["hrsh7th/cmp-nvim-lsp"
                         "hrsh7th/cmp-buffer"
                         "hrsh7th/cmp-path"
                         "hrsh7th/cmp-cmdline"
                         "hrsh7th/cmp-vsnip"]})

    (use "vale1410/vim-minizinc")

    (use "nelstrom/vim-textobj-rubyblock"
         {:dependencies ["kana/vim-textobj-user"]})

    (use "iamcco/markdown-preview.nvim"
         {:build "cd app && env COREPACK_ENABLE_AUTO_PIN=0 yarn install"})

    ; Navigation

    (use "nvim-telescope/telescope.nvim"
         {:config #(require :local.plugins.telescope)
          :dependencies ["nvim-telescope/telescope-fzy-native.nvim"
                         "nvim-telescope/telescope-ui-select.nvim"]})

    (use "nvim-neo-tree/neo-tree.nvim"
         {:branch "v3.x"
          :config #(require :local.plugins.neo-tree)
          :dependencies ["MunifTanjim/nui.nvim"]})

    (use "aaronik/treewalker.nvim"
         {:config #(require :local.plugins.treewalker)})

    ; Color

    (use "rf-/edge"
         {:config #(require :local.plugins.edge)})
  ])

(fn init []
  (set package.path (.. (fs.normalize "~") "/.config/nvim/lua/?.lua,"
                        package.path))
  (local lazy (bootstrap-lazy))
  (require :local.core)
  (lazy.setup {:spec (plugin-specs) :checker {:enabled false}})
  (require :local.commands))

(if (not g.vscode) (init))
