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
    return require("local.plugins.conjure")
  end
  local function _4_()
    return require("local.plugins.nerdcommenter")
  end
  local function _5_()
    return require("local.plugins.fugitive")
  end
  local function _6_()
    return require("local.plugins.gitgutter")
  end
  local function _7_()
    return require("local.plugins.bclose")
  end
  local function _8_()
    return require("local.plugins.splitjoin")
  end
  local function _9_()
    return require("local.plugins.mundo")
  end
  local function _10_()
    return require("local.plugins.vsnip")
  end
  local function _11_()
    return require("local.plugins.copilot-chat")
  end
  local function _12_()
    return require("local.plugins.polyglot")
  end
  local function _13_()
    return require("local.plugins.treesitter")
  end
  local function _14_()
    return require("local.plugins.lspconfig")
  end
  local function _15_()
    return require("local.plugins.lspsaga")
  end
  local function _16_()
    return require("local.plugins.lsp-file-operations")
  end
  local function _17_()
    return require("local.plugins.trouble")
  end
  local function _18_()
    return require("local.plugins.echo-diagnostics")
  end
  local function _19_()
    return require("local.plugins.cmp")
  end
  local function _20_()
    return require("local.plugins.telescope")
  end
  local function _21_()
    return require("local.plugins.neo-tree")
  end
  local function _22_()
    return require("local.plugins.treewalker")
  end
  local function _23_()
    return require("local.plugins.edge")
  end
  return {use("nvim-lua/plenary.nvim"), use("Olical/nfnl"), use("Olical/conjure", {init = _3_}), use("godlygeek/tabular"), use("justinmk/vim-sneak"), use("tpope/vim-endwise"), use("tpope/vim-repeat"), use("tpope/vim-speeddating"), use("tpope/vim-surround"), use("tpope/vim-unimpaired"), use("kana/vim-textobj-user"), use("glts/vim-textobj-comment", {dependencies = {"kana/vim-textobj-user"}}), use("preservim/nerdcommenter", {init = _4_}), use("tpope/vim-fugitive", {config = _5_}), use("tpope/vim-rhubarb"), use("airblade/vim-gitgutter", {config = _6_}), use("rf-/vim-bclose", {config = _7_}), use("AndrewRadev/splitjoin.vim", {config = _8_}), use("simnalamburt/vim-mundo", {init = _9_}), use("hrsh7th/vim-vsnip", {init = _10_}), use("github/copilot.vim"), use("CopilotC-Nvim/CopilotChat.nvim", {branch = "main", config = _11_}), use("sheerun/vim-polyglot", {init = _12_}), use("rf-/yats.vim"), use("nvim-treesitter/nvim-treesitter", {config = _13_}), use("neovim/nvim-lspconfig", {config = _14_, dependencies = {"hrsh7th/cmp-nvim-lsp"}}), use("nvimtools/none-ls.nvim"), use("nvimdev/lspsaga.nvim", {config = _15_}), use("antosha417/nvim-lsp-file-operations", {config = _16_, dependencies = {"nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim"}}), use("folke/trouble.nvim", {config = _17_, version = "v2.10.0"}), use("seblj/nvim-echo-diagnostics", {config = _18_}), use("hrsh7th/nvim-cmp", {config = _19_, dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "hrsh7th/cmp-vsnip"}}), use("vale1410/vim-minizinc"), use("nelstrom/vim-textobj-rubyblock", {dependencies = {"kana/vim-textobj-user"}}), use("iamcco/markdown-preview.nvim", {build = "cd app && env COREPACK_ENABLE_AUTO_PIN=0 yarn install"}), use("nvim-telescope/telescope.nvim", {config = _20_, dependencies = {"nvim-telescope/telescope-fzy-native.nvim", "nvim-telescope/telescope-ui-select.nvim"}}), use("nvim-neo-tree/neo-tree.nvim", {branch = "v3.x", config = _21_, dependencies = {"MunifTanjim/nui.nvim"}}), use("aaronik/treewalker.nvim", {config = _22_}), use("rf-/edge", {config = _23_})}
end
local function init()
  package.path = (fs.normalize("~") .. "/.config/nvim/lua/?.lua," .. package.path)
  local lazy = bootstrap_lazy()
  require("local.core")
  lazy.setup({spec = plugin_specs(), checker = {enabled = false}})
  return require("local.commands")
end
if not g.vscode then
  return init()
else
  return nil
end
