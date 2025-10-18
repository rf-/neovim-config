-- [nfnl] fnl/local/core.fnl
local g = vim["g"]
local o = vim["o"]
local bo = vim["bo"]
local wo = vim["wo"]
local env = vim["env"]
local opt = vim["opt"]
local keymap = vim["keymap"]
local map_21 = keymap["set"]
local command = vim.api["nvim_command"]
local autocmd = vim.api["nvim_create_autocmd"]
local str = require("std.string")
local u = require("local.utils")
g.mapleader = " "
g.maplocalleader = " "
do
  local python_2_path = env.NEOVIM_PYTHON2_PATH
  local python_3_path = env.NEOVIM_PYTHON3_PATH
  if python_2_path then
    g.python_host_prog = python_2_path
  else
  end
  if python_3_path then
    g.python3_host_prog = python_3_path
  else
  end
end
o.ambiwidth = "single"
o.autoread = true
o.colorcolumn = "+1"
o.expandtab = true
o.hidden = true
o.mouse = "a"
o.number = true
o.shiftwidth = 2
o.showmode = false
o.smarttab = true
o.softtabstop = 2
o.tabstop = 8
o.termguicolors = true
o.wrap = true
o.breakindent = true
o.linebreak = true
o.showbreak = "\226\134\179 "
do
  local system_style = str.trim(u.system("defaults read -g AppleInterfaceStyle"))
  if (system_style == "Dark") then
    o.background = "dark"
  else
    o.background = "light"
  end
end
o.list = true
o.listchars = "tab:  ,trail:\194\183"
o.formatoptions = "croqj"
o.textwidth = 79
o.joinspaces = false
o.winwidth = 88
o.splitbelow = true
o.splitright = true
o.scrolloff = 1
o.sidescrolloff = 5
o.history = 1000
o.undofile = true
o.undodir = vim.fn.expand("~/.config/nvim/undo")
o.undolevels = 2000
o.undoreload = 20000
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.backupdir = vim.fn.expand("~/.config/nvim/backup//")
o.directory = vim.fn.expand("~/.config/nvim/swap//")
o.clipboard = "unnamedplus"
opt.shortmess:append("c")
o.showmatch = true
o.matchtime = 1
o.pumblend = 20
o.winblend = 10
o.wildoptions = "pum"
o.wildmode = "longest:full"
o.completeopt = "menu,menuone,noselect"
o.inccommand = "nosplit"
o.signcolumn = "number"
g.terminal_scrollback_buffer_size = 100000
o.exrc = true
map_21({"n"}, "Y", "y$")
map_21({"n"}, "~", "`")
map_21({"n", "v"}, "Q", "@q")
map_21({"i"}, "<M-k>", "<C-k>")
map_21({"n", "v"}, "<Down>", "gj")
map_21({"n", "v"}, "<Up>", "gk")
map_21({"i"}, "<Down>", "<C-o>gj")
map_21({"i"}, "<Up>", "<C-o>gk")
for c_u_or_d, j_or_k in pairs({["<C-d>"] = "j", ["<C-u>"] = "k"}) do
  local function _4_()
    return command(("normal! " .. vim.wo.scroll .. j_or_k))
  end
  map_21({"n"}, c_u_or_d, _4_, {silent = true})
end
for _, key in pairs({"h", "j", "k", "l"}) do
  map_21({"t", "n", "v", "i"}, ("<C-" .. key .. ">"), ("<C-\\><C-n><C-w>" .. key))
end
map_21({"n", "v"}, "<C-w><C-p>", ":pclose!<CR>")
map_21({"n", "v"}, "<Leader>#", ":e#<CR>")
map_21({"n", "v"}, "<Leader>3", ":e#<CR>")
map_21({"n", "v"}, "<Leader>e", ":bel 10split term://pry<CR>")
map_21({"n", "v"}, "<Leader>h", ":nohlsearch<CR>")
local function _5_()
  wo.relativenumber = not wo.relativenumber
  return nil
end
map_21({"n", "v"}, "<Leader>r", _5_, {silent = true})
map_21({"n"}, "<Leader>w", ":w<CR>")
map_21({"n", "v"}, "<Leader>q", ":q<CR>")
local function _6_()
  return vim.diagnostic.open_float()
end
map_21({"n"}, "<Leader>gd", _6_, {silent = true})
map_21({"n"}, "<Leader>/", "gcc", {remap = true})
map_21({"v"}, "<Leader>/", "gc", {remap = true})
local function _7_()
  return print(u["inspect-syntax-group"]())
end
map_21({"n", "v"}, "<F10>", _7_, {silent = true})
map_21({"t", "n", "v", "i"}, "<C-\\><C-[>", "<C-\\><C-n>gT")
map_21({"t", "n", "v", "i"}, "<C-\\><C-]>", "<C-\\><C-n>gt")
map_21({"t", "n", "v", "i"}, "<C-\\><C-t>", "<C-\\><C-n>:split<CR><C-\\><C-n>:term<CR>")
map_21({"t", "n", "v", "i"}, "<C-\\><C-v>", "<C-\\><C-n>:vsplit<CR><C-\\><C-n>:term<CR>")
map_21({"t"}, "<C-\\><C-p>", "<C-\\><C-n>p")
map_21({"t"}, "<C-\\><C-\\>", "<C-\\><C-n>")
map_21({"t"}, "<M-k>", "<C-k>")
command("nmap <expr> <CR> &buftype == 'terminal' ? \"i\\<CR>\" : \"\\<CR>\"")
local function _8_()
  do
    local saved_line_nr = vim.fn.line("'\"")
    local last_line_nr = vim.fn.line("$")
    if ((saved_line_nr > 0) and (saved_line_nr <= last_line_nr)) then
      command("normal g'\"")
    else
    end
  end
  return nil
end
autocmd("BufReadPost", {pattern = "*", callback = _8_})
local function _10_()
  wo.scroll = math.floor((vim.fn.winheight(0) / 4))
  return nil
end
autocmd({"BufReadPost", "WinEnter"}, {pattern = "*", callback = _10_})
local function _11_()
  do
    local last_line_on_screen_nr = vim.fn.line("w$")
    local last_line_nr = vim.fn.line("$")
    if (last_line_on_screen_nr >= last_line_nr) then
      command("startinsert")
    else
    end
  end
  return nil
end
autocmd({"TermOpen", "BufWinEnter", "WinEnter"}, {pattern = "term://*", callback = _11_})
autocmd({"TermOpen", "BufWinEnter"}, {pattern = "term://*", command = "setlocal nonumber"})
autocmd({"BufWinLeave"}, {pattern = "term://*", command = "setlocal number"})
g.omni_sql_no_default_maps = true
command("highlight clear SignColumn")
command("highlight link rustCommentLineDoc Comment")
autocmd({"BufRead", "BufNewFile"}, {pattern = "*", command = "setlocal formatoptions-=l"})
autocmd({"BufReadPost", "BufNewFile"}, {pattern = "*.mm", command = "set filetype=objcpp"})
do
  local filetype_settings = {coffee = {shiftwidth = 2, softtabstop = 2}, css = {shiftwidth = 2, softtabstop = 2}, go = {tabstop = 4, shiftwidth = 4, expandtab = false}, haxe = {tabstop = 4, shiftwidth = 4, softtabstop = 4}, javascript = {shiftwidth = 2, softtabstop = 2}, make = {expandtab = false}, python = {shiftwidth = 4, softtabstop = 4, textwidth = 79}, scala = {textwidth = 99}, scss = {shiftwidth = 2, softtabstop = 2}, typescript = {shiftwidth = 2, softtabstop = 2}, typescriptreact = {shiftwidth = 2, softtabstop = 2}}
  for filetype, settings in pairs(filetype_settings) do
    local function _13_()
      for setting, value in pairs(settings) do
        bo[setting] = value
      end
      return nil
    end
    autocmd({"FileType"}, {pattern = filetype, callback = _13_})
  end
end
autocmd({"FileType"}, {pattern = "fennel", command = "setlocal iskeyword-=."})
autocmd({"FileType"}, {pattern = "ruby", command = "setlocal iskeyword+=!,?"})
autocmd({"BufRead", "BufNewFile"}, {pattern = "*.txt", command = "setlocal wrap wrapmargin=2 textwidth=72"})
autocmd({"BufRead", "BufNewFile"}, {pattern = "{Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}", command = "set filetype=ruby"})
autocmd({"BufRead", "BufNewFile"}, {pattern = "*.{mts,cts}", command = "set filetype=typescript"})
autocmd({"BufRead", "BufNewFile"}, {pattern = "*.dict", command = "set filetype=dict"})
local function _14_()
  for idx, score in ipairs({0, 10, 21, 51, 61}) do
    local function _15_()
      return ("0f;lciw" .. score .. "<Esc>:noh<CR>")
    end
    map_21({"n"}, tostring(idx), _15_)
  end
  return nil
end
autocmd({"FileType"}, {pattern = "dict", callback = _14_})
autocmd({"QuickFixCmdPost"}, {pattern = "[^l]*", command = "cwindow", nested = true})
autocmd({"QuickFixCmdPost"}, {pattern = "l*", command = "lwindow", nested = true})
vim.diagnostic.config({underline = true, signs = true, update_in_insert = true, severity_sort = true, virtual_text = false})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {silent = true, focusable = false})
local function _16_()
  return vim.diagnostic.goto_prev({float = false})
end
map_21({"n"}, "[d", _16_, {silent = true})
local function _17_()
  return vim.diagnostic.goto_next({float = false})
end
return map_21({"n"}, "]d", _17_, {silent = true})
