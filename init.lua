-- [nfnl] Compiled from init.fnl by https://github.com/Olical/nfnl, do not edit.
vim.loader.enable()
local g = vim["g"]
local env = vim["env"]
local fs = vim["fs"]
local command = vim.api["nvim_command"]
local stdpath = vim.fn["stdpath"]
local empty = vim.fn["empty"]
local glob = vim.fn["glob"]
local format = string["format"]
local function init()
  local pack_path = (stdpath("data") .. "/site/pack")
  local function ensure(user, repo)
    local install_path = format("%s/packer/start/%s", pack_path, repo)
    if (empty(glob(install_path)) > 0) then
      return command(format("!git clone https://github.com/%s/%s %s", user, repo, install_path))
    else
      return command(format("packadd %s", repo))
    end
  end
  ensure("wbthomason", "packer.nvim")
  local packer = require("packer")
  local function use(name, opts)
    local opts0 = (opts or {})
    opts0[1] = name
    return packer.use(opts0)
  end
  local function _2_()
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim")
    use("Olical/nfnl")
    use("tsbohc/zest.nvim")
    use("godlygeek/tabular")
    use("jeetsukumaran/vim-indentwise")
    use("justinmk/vim-sneak")
    use("tpope/vim-endwise")
    use("tpope/vim-repeat")
    use("tpope/vim-speeddating")
    use("tpope/vim-surround")
    use("tpope/vim-unimpaired")
    use("kana/vim-textobj-user")
    use("glts/vim-textobj-comment")
    use("preservim/nerdcommenter")
    use("tpope/vim-fugitive")
    use("tpope/vim-rhubarb")
    use("airblade/vim-gitgutter")
    use("rf-/vim-bclose")
    use("AndrewRadev/splitjoin.vim")
    use("simnalamburt/vim-mundo")
    use("hrsh7th/vim-vsnip")
    local function _3_()
      local copilot = require("copilot")
      return copilot.setup({})
    end
    use("zbirenbaum/copilot.lua", {cmd = "Copilot", event = "InsertEnter", config = _3_})
    local function _4_()
      local copilot_chat = require("CopilotChat")
      return copilot_chat.setup({})
    end
    use("CopilotC-Nvim/CopilotChat.nvim", {branch = "canary", config = _4_})
    g.polyglot_disabled = {"typescript"}
    use("sheerun/vim-polyglot")
    use("rf-/yats.vim")
    use("nvim-treesitter/nvim-treesitter")
    use("neovim/nvim-lspconfig")
    use("nvimtools/none-ls.nvim")
    use("folke/trouble.nvim", {tag = "v2.10.0"})
    use("seblj/nvim-echo-diagnostics")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/cmp-vsnip")
    use("hrsh7th/nvim-cmp")
    use("vale1410/vim-minizinc")
    use("nelstrom/vim-textobj-rubyblock")
    use("iamcco/markdown-preview.nvim", {run = "cd app && yarn install"})
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-fzy-native.nvim")
    use("nvim-telescope/telescope-ui-select.nvim")
    use("preservim/nerdtree")
    return use("rf-/edge")
  end
  packer.startup(_2_)
  package.path = (fs.normalize("~") .. "/.config/nvim/lua/?.lua," .. package.path)
  if not env.PACKER_SYNC then
    require("local.core")
    require("local.plugins")
    return require("local.commands")
  else
    return nil
  end
end
if not g.vscode then
  return init()
else
  return nil
end
