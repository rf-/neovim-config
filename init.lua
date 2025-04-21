-- [nfnl] init.fnl
vim.loader.enable()
local g = vim["g"]
local env = vim["env"]
local fs = vim["fs"]
local command = vim.api["nvim_command"]
local stdpath = vim.fn["stdpath"]
local empty = vim.fn["empty"]
local glob = vim.fn["glob"]
local format = string["format"]
local function bootstrap_lazy()
  local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
  if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if (vim.v.shell_error ~= 0) then
      vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out}, {"\nPress any key to exit..."}}, true, {})
      vim.fn.getchar()
      os.exit(1)
    else
    end
  else
  end
  vim.opt.rtp:prepend(lazypath)
  return require("lazy")
end
local function plugin_specs()
  local function use(name, opts)
    local opts0 = (opts or {})
    opts0[1] = name
    return opts0
  end
  local function _3_()
    g.polyglot_disabled = {"typescript"}
    return nil
  end
  return {use("wbthomason/packer.nvim"), use("nvim-lua/plenary.nvim"), use("Olical/nfnl"), use("Olical/conjure"), use("godlygeek/tabular"), use("justinmk/vim-sneak"), use("tpope/vim-endwise"), use("tpope/vim-repeat"), use("tpope/vim-speeddating"), use("tpope/vim-surround"), use("tpope/vim-unimpaired"), use("kana/vim-textobj-user"), use("glts/vim-textobj-comment", {dependencies = {"kana/vim-textobj-user"}}), use("preservim/nerdcommenter"), use("tpope/vim-fugitive"), use("tpope/vim-rhubarb"), use("airblade/vim-gitgutter"), use("rf-/vim-bclose"), use("AndrewRadev/splitjoin.vim"), use("simnalamburt/vim-mundo"), use("hrsh7th/vim-vsnip"), use("github/copilot.vim"), use("CopilotC-Nvim/CopilotChat.nvim", {branch = "main"}), use("sheerun/vim-polyglot", {init = _3_}), use("rf-/yats.vim"), use("nvim-treesitter/nvim-treesitter"), use("neovim/nvim-lspconfig"), use("nvimtools/none-ls.nvim"), use("nvimdev/lspsaga.nvim"), use("antosha417/nvim-lsp-file-operations", {dependencies = {"nvim-neo-tree/neo-tree.nvim"}}), use("folke/trouble.nvim", {version = "v2.10.0"}), use("seblj/nvim-echo-diagnostics"), use("hrsh7th/cmp-nvim-lsp"), use("hrsh7th/cmp-buffer"), use("hrsh7th/cmp-path"), use("hrsh7th/cmp-cmdline"), use("hrsh7th/cmp-vsnip"), use("hrsh7th/nvim-cmp"), use("vale1410/vim-minizinc"), use("nelstrom/vim-textobj-rubyblock", {dependencies = {"kana/vim-textobj-user"}}), use("iamcco/markdown-preview.nvim", {build = "cd app && env COREPACK_ENABLE_AUTO_PIN=0 yarn install"}), use("nvim-telescope/telescope.nvim"), use("nvim-telescope/telescope-fzy-native.nvim"), use("nvim-telescope/telescope-ui-select.nvim"), use("nvim-neo-tree/neo-tree.nvim", {branch = "v3.x", dependencies = {"MunifTanjim/nui.nvim"}}), use("aaronik/treewalker.nvim"), use("rf-/edge")}
end
local function init()
  local lazy = bootstrap_lazy()
  require("local.core")
  lazy.setup({spec = plugin_specs(), checker = {enabled = true}})
  package.path = (fs.normalize("~") .. "/.config/nvim/lua/?.lua," .. package.path)
  require("local.plugins")
  return require("local.commands")
end
if not g.vscode then
  return init()
else
  return nil
end
