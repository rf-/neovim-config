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
local function next_ancestor_down(node, row, last_row)
  if node then
    local erow = nodes.get_erow(node)
    local target_row
    if (erow > last_row) then
      target_row = last_row
    else
      target_row = erow
    end
    if (target_row > row) then
      return {node, target_row}
    else
      return next_ancestor_down(node:parent(), row, last_row)
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
  local last_row = vim.fn.line("$")
  local _let_5_ = (default_down() or next_ancestor_down(node, current_row, last_row) or {nil, nil})
  local target = _let_5_[1]
  local row = _let_5_[2]
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
local function _9_()
  return move_down()
end
map_21({"n"}, "<C-=>", _9_, {silent = true})
map_21({"n"}, "<C-S-->", ":Treewalker SwapLeft<CR>", {silent = true})
return map_21({"n"}, "<C-S-=>", ":Treewalker SwapRight<CR>", {silent = true})
