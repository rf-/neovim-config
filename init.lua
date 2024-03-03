-- Based on https://github.com/Olical/dotfiles

-- Optimize Lua loading
vim.loader.enable()

local cmd = vim.api.nvim_command
local fn = vim.fn
local fmt = string.format

local pack_path = fn.stdpath("data") .. "/site/pack"

function ensure(user, repo)
  local install_path = fmt("%s/packer/start/%s", pack_path, repo)
  if fn.empty(fn.glob(install_path)) > 0 then
    cmd(fmt("!git clone https://github.com/%s/%s %s", user, repo, install_path))
    cmd(fmt("packadd %s", repo))
  end
end

ensure("wbthomason", "packer.nvim")

require("packer").startup(function ()
  -- Basic Packer/Fennel/Lua setup

  use "wbthomason/packer.nvim"
  use "Olical/aniseed"
  use "Olical/conjure"
  use "Olical/nvim-local-fennel"
  use "tsbohc/zest.nvim"

  use "nvim-lua/plenary.nvim"

  -- Ergonomics

  use "godlygeek/tabular"
  use "jeetsukumaran/vim-indentwise"
  use "justinmk/vim-sneak"
  use "tpope/vim-endwise"
  use "tpope/vim-repeat"
  use "tpope/vim-speeddating"
  use "tpope/vim-surround"
  use "tpope/vim-unimpaired"

  use "kana/vim-textobj-user"
  use "glts/vim-textobj-comment"

  use "preservim/nerdcommenter"

  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"

  use "airblade/vim-gitgutter"

  use "rf-/vim-bclose"

  use "AndrewRadev/splitjoin.vim"

  use "simnalamburt/vim-mundo"

  -- Snippets

  use "hrsh7th/vim-vsnip"
  use "github/copilot.vim"

  -- Language support

  vim.g["polyglot_disabled"] = {"typescript"}
  use "sheerun/vim-polyglot"
  use "rf-/yats.vim"
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  use "neovim/nvim-lspconfig"
  use "nvimtools/none-ls.nvim"

  use "folke/trouble.nvim"
  use "seblj/nvim-echo-diagnostics"

  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-vsnip"
  use "hrsh7th/nvim-cmp"

  use "vale1410/vim-minizinc"
  use "nelstrom/vim-textobj-rubyblock"

  use { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" }

  -- Navigation

  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-fzy-native.nvim"
  use "nvim-telescope/telescope-ui-select.nvim"

  use "preservim/nerdtree"

  -- Color

  use "rf-/edge"
end)

-- Fix Packer or whatever breaking load path
package.path = vim.fs.normalize("~") .. "/.config/nvim/lua/?.lua," .. package.path

if not vim.env.PACKER_SYNC then
  vim.g["aniseed#env"] = {
    module = "local.init",
    compile = true
  }
end
