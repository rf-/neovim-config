-- [nfnl] fnl/local/plugins/neo-tree.fnl
local g = vim["g"]
local keymap = vim["keymap"]
local wait = vim["wait"]
local map_21 = keymap["set"]
local neo_tree = require("neo-tree")
local neo_tree_fs = require("neo-tree.sources.filesystem")
local neo_tree_renderer = require("neo-tree.ui.renderer")
map_21({"n", "v"}, "<Leader>n", ":Neotree toggle<CR>")
map_21({"n", "v"}, "<Leader>N", ":Neotree<CR>")
map_21({"n", "v"}, "-", ":Neotree reveal<CR>")
local function open_dir(state, dir_node)
  neo_tree_fs.toggle_directory(state, dir_node, nil, true, false)
  return wait(50)
end
local function open_all_from_root(state, root_node, max_depth)
  local max_depth_reached = 1
  local stack = {root_node}
  while (next(stack) ~= nil) do
    local node = table.remove(stack)
    local depth = node:get_depth()
    local max_depth_reached0 = math.max(depth, max_depth_reached)
    if ((node.type == "directory") and not node:is_expanded()) then
      open_dir(state, node)
    else
    end
    if (not max_depth or (depth < (max_depth - 1))) then
      local children = state.tree:get_nodes(node:get_id())
      for _, v in ipairs(children) do
        table.insert(stack, v)
      end
    else
    end
  end
  return max_depth_reached
end
local function open_all_under_cursor(state)
  open_all_from_root(state, state.tree:get_node(), 5)
  return neo_tree_renderer.redraw(state)
end
return neo_tree.setup({default_component_configs = {icon = {folder_closed = "\226\150\184", folder_open = "\226\150\190", folder_empty = "\195\151", default = " "}, name = {trailing_slash = true}, git_status = {symbols = {added = "\226\156\154", modified = "\226\136\180", renamed = "\226\134\148", untracked = "?", ignored = "\226\138\151", unstaged = "", staged = "", conflict = ""}}}, window = {width = 32, mappings = {O = open_all_under_cursor, I = "toggle_hidden", ["/"] = "noop", ["~"] = "fuzzy_finder"}}})
