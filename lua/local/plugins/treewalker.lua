-- [nfnl] Compiled from fnl/local/plugins/treewalker.fnl by https://github.com/Olical/nfnl, do not edit.
local treewalker = require("treewalker")
local nodes = require("treewalker.nodes")
local targets = require("treewalker.targets")
local operations = require("treewalker.operations")
local map_21 = vim.keymap["set"]
treewalker.setup({highlight = false})
local function default_down()
  local target, row = targets.down()
  if target then
    return {target, row}
  else
    return nil
  end
end
local function next_ancestor_down(node, row)
  if (node and (node:type() ~= "source_file")) then
    local erow = nodes.get_erow(node)
    if (erow > row) then
      return {node, erow}
    else
      return next_ancestor_down(node:parent(), row)
    end
  else
    return nil
  end
end
local function update_jump_list()
  return vim.cmd("normal! m'")
end
local function move_down()
  local node = nodes.get_current()
  local current_row = vim.fn.line(".")
  local _let_4_ = (default_down() or next_ancestor_down(node, current_row) or {nil, nil})
  local target = _let_4_[1]
  local row = _let_4_[2]
  local is_neighbor = (row and (row == (current_row + 1)))
  if target then
    if not is_neighbor then
      update_jump_list()
    else
    end
    operations.jump(target, row)
    if not is_neighbor then
      return update_jump_list()
    else
      return nil
    end
  else
    return nil
  end
end
map_21({"n"}, "[-", ":Treewalker Left<CR>", {silent = true})
map_21({"n"}, "]-", ":Treewalker Right<CR>", {silent = true})
map_21({"n"}, "<C-->", ":Treewalker Up<CR>", {silent = true})
local function _8_()
  return move_down()
end
map_21({"n"}, "<C-=>", _8_, {silent = true})
map_21({"n"}, "<C-S-->", ":Treewalker SwapLeft<CR>", {silent = true})
return map_21({"n"}, "<C-S-=>", ":Treewalker SwapRight<CR>", {silent = true})
