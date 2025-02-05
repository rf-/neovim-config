-- [nfnl] Compiled from fnl/local/plugins.fnl by https://github.com/Olical/nfnl, do not edit.
local ex = vim["ex"]
local g = vim["g"]
local command = vim.api["nvim_command"]
local function config(name)
  local ok_3f, val_or_err = pcall(require, ("local.plugins." .. name))
  if not ok_3f then
    return print(("Error loading plugin config: " .. val_or_err))
  else
    return nil
  end
end
config("neo-tree")
config("nerdcommenter")
config("fugitive")
config("gitgutter")
config("bclose")
config("splitjoin")
config("mundo")
config("treesitter")
config("lspconfig")
config("cmp")
config("vsnip")
config("telescope")
config("trouble")
config("echo-diagnostics")
config("lspsaga")
config("copilot")
config("treewalker")
g.edge_style = "aura"
g.edge_enable_italic = 1
return command("colorscheme edge")
