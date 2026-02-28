-- [nfnl] fnl/local/plugins/treewalker.fnl
local treewalker = require("treewalker")
local nodes = require("treewalker.nodes")
local targets = require("treewalker.targets")
local operations = require("treewalker.operations")
local map_21 = vim.keymap.set
treewalker.setup({scope_confined = true, highlight = false})
local function should_confine_vertical_move(current_node, candidate)
  local current_parent = nodes.scope_parent(current_node)
  local candidate_anchor = nodes.get_highest_row_coincident(candidate)
  if (current_parent and candidate_anchor) then
    return not nodes.is_descendant_of(current_parent, candidate_anchor)
  else
    return nil
  end
end
local function up_target(current_node, current_row)
  local target, row = targets.up(current_node, current_row)
  if (target and not should_confine_vertical_move(current_node, target)) then
    return target, row
  else
    return nil, nil
  end
end
local function down_target(current_node, current_row)
  local target, row = targets.down(current_node, current_row)
  if (target and not should_confine_vertical_move(current_node, target)) then
    return target, row
  else
    return nil, nil
  end
end
local function up_or_jump_target(current_node, current_row)
  return targets.up(current_node, current_row)
end
local function down_or_jump_target(current_node, current_row)
  return targets.down(current_node, current_row)
end
local function up_or_out_target(from_node, from_row)
  local prev_node, prev_row = up_target(from_node, from_row)
  local from_srow = nodes.get_srow(from_node)
  local parent_node = from_node:parent()
  local parent_srow
  if parent_node then
    parent_srow = nodes.get_srow(parent_node)
  else
    parent_srow = nil
  end
  if prev_node then
    return prev_node, prev_row
  else
    if (from_row ~= from_srow) then
      return from_node, from_srow
    else
      if (from_row ~= parent_srow) then
        return parent_node, parent_srow
      else
        return up_or_out_target(parent_node, parent_srow)
      end
    end
  end
end
local function down_or_out_target(from_node, from_row)
  local next_node, next_row = down_target(from_node, from_row)
  local from_erow = nodes.get_erow(from_node)
  local parent_node = from_node:parent()
  local parent_erow
  if parent_node then
    parent_erow = nodes.get_erow(parent_node)
  else
    parent_erow = nil
  end
  if next_node then
    return next_node, next_row
  else
    if (from_row ~= from_erow) then
      return from_node, from_erow
    else
      if (from_row ~= parent_erow) then
        return parent_node, parent_erow
      else
        return down_or_out_target(parent_node, parent_erow)
      end
    end
  end
end
local function update_jump_list()
  return vim.cmd("normal! m'")
end
local function move(get_target)
  local current_node, current_row = nodes.get_highest_node_at_current_row()
  local target, row = get_target(current_node, current_row)
  if target then
    local is_neighbor = nodes.have_neighbor_srow(current_node, target)
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
local function _15_()
  return move(up_target)
end
map_21({"n"}, "-", _15_, {silent = true})
local function _16_()
  return move(down_target)
end
map_21({"n"}, "=", _16_, {silent = true})
local function _17_()
  return move(up_or_jump_target)
end
map_21({"n"}, "<C-->", _17_, {silent = true})
local function _18_()
  return move(down_or_jump_target)
end
map_21({"n"}, "<C-=>", _18_, {silent = true})
map_21({"n"}, "<S-->", ":Treewalker Left<CR>", {silent = true})
map_21({"n"}, "<S-=>", ":Treewalker Right<CR>", {silent = true})
local function _19_()
  return move(up_or_out_target)
end
map_21({"n"}, "<C-S-->", _19_, {silent = true})
local function _20_()
  return move(down_or_out_target)
end
map_21({"n"}, "<C-S-=>", _20_, {silent = true})
map_21({"n"}, "<A-->", ":Treewalker SwapLeft<CR>", {silent = true})
map_21({"n"}, "<A-=>", ":Treewalker SwapRight<CR>", {silent = true})
map_21({"n"}, "<A-S-->", ":Treewalker SwapUp<CR>", {silent = true})
return map_21({"n"}, "<A-S-=>", ":Treewalker SwapDown<CR>", {silent = true})
