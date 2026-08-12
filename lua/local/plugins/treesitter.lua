-- [nfnl] fnl/local/plugins/treesitter.fnl
local command = vim.api.nvim_command
local autocmd = vim.api.nvim_create_autocmd
local create_command = vim.api.nvim_create_user_command
local _local_1_ = require("std.table")
local keys = _local_1_.keys
local ts = require("nvim-treesitter")
local all_parsers = keys(require("nvim-treesitter.parsers"))
local u = require("local.utils")
local function task_3f(x)
  return ((type(x) == "table") and (type(x.await) == "function"))
end
local function without_message_prompts(f)
  local saved_more = vim.o.more
  local saved_messagesopt = vim.o.messagesopt
  vim.o.more = false
  vim.o.messagesopt = "wait:0,history:500,progress:c"
  local restore
  local function _2_()
    vim.o.more = saved_more
    vim.o.messagesopt = saved_messagesopt
    return nil
  end
  restore = _2_
  local ok_3f, result = pcall(f)
  if not ok_3f then
    restore()
    error(result)
  else
  end
  if task_3f(result) then
    local function _4_()
      return vim.schedule(restore)
    end
    result:await(_4_)
  else
    restore()
  end
  return result
end
local function build()
  local function _6_()
    ts.install(all_parsers):wait(300000)
    return ts.update(all_parsers):wait(300000)
  end
  return without_message_prompts(_6_)
end
local function rebuild_all()
  u.system("rm -rf ~/.local/share/nvim/site")
  local function _7_()
    return ts.install(all_parsers, {force = true})
  end
  return without_message_prompts(_7_)
end
create_command("TSRebuildAll", rebuild_all, {})
local function config()
  local filetype_set = {}
  for _, parser in ipairs(all_parsers) do
    for _0, filetype in ipairs(vim.treesitter.language.get_filetypes(parser)) do
      filetype_set[filetype] = true
    end
  end
  local function _8_()
    vim.treesitter.start()
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    return nil
  end
  return autocmd("FileType", {pattern = keys(filetype_set), callback = _8_})
end
return {build = build, config = config}
