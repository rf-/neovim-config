-- [nfnl] fnl/local/plugins/telescope.fnl
local _local_1_ = require("std.functional")
local map = _local_1_["map"]
local bind = _local_1_["bind"]
local foldl = _local_1_["foldl"]
local _local_2_ = require("std.table")
local merge = _local_2_["merge"]
local telescope = require("telescope")
local telescope_action_state = require("telescope.actions.state")
local telescope_actions = require("telescope.actions")
local telescope_builtin = require("telescope.builtin")
local telescope_from_entry = require("telescope.from_entry")
local telescope_themes = require("telescope.themes")
local keymap = vim["keymap"]
local map_21 = keymap["set"]
local command = vim.api["nvim_command"]
local function entry_to_qf(entry)
  local or_3_ = entry.text
  if not or_3_ then
    if (type(entry.value) == "table") then
      or_3_ = entry.value.text
    else
      or_3_ = entry.value
    end
  end
  return {bufnr = entry.bufnr, filename = telescope_from_entry.path(entry, false), lnum = (entry.lnum or 1), col = (entry.col or 1), text = or_3_}
end
local function map_vals(func, tbl)
  local function _5_(_241, _242)
    return func(_242)
  end
  return map(_5_, tbl)
end
local function escape_filename(filename)
  return vim.fn.escape(filename, " %#'\"")
end
local function open_one_or_more(cmd, qf_or_args, prompt_bufnr)
  local picker = telescope_action_state.get_current_picker(prompt_bufnr)
  local multi_selection = picker:get_multi_selection()
  local has_multi = (#multi_selection > 0)
  local selection
  if has_multi then
    selection = multi_selection
  else
    selection = {picker:get_selection()}
  end
  local qfs = map_vals(entry_to_qf, selection)
  telescope_actions.close(prompt_bufnr)
  if (#qfs > 0) then
    local qf = qfs[1]
    command((cmd .. " " .. escape_filename(qf.filename)))
    command(("normal! " .. qf.lnum .. "G" .. qf.col .. "|zz"))
  else
  end
  if ((#qfs > 1) and (qf_or_args == "qf")) then
    vim.fn.setqflist(qfs)
    command("copen")
    command("wincmd J")
    command("10 wincmd _")
    command("wincmd p")
  else
  end
  if ((#qfs > 1) and (qf_or_args == "args")) then
    local filenames
    local function _9_(_241)
      return escape_filename(_241.filename)
    end
    filenames = map_vals(_9_, qfs)
    return command(("args " .. table.concat(filenames, " ")))
  else
    return nil
  end
end
local function map_all(mappings)
  return {i = mappings, n = mappings}
end
local grep_mappings = map_all({["<Enter>"] = bind(open_one_or_more, {"edit", "qf"}), ["<C-s>"] = bind(open_one_or_more, {"split", "qf"}), ["<C-v>"] = bind(open_one_or_more, {"vsplit", "qf"})})
local file_mappings = map_all({["<Enter>"] = bind(open_one_or_more, {"edit", "args"}), ["<C-s>"] = bind(open_one_or_more, {"split", "args"}), ["<C-v>"] = bind(open_one_or_more, {"vsplit", "args"})})
telescope.setup({defaults = {winblend = 5, path_display = {"truncate"}, layout_strategy = "bottom_pane", layout_config = {bottom_pane = {height = 15, prompt_position = "bottom"}}, mappings = map_all({["<C-a>"] = telescope_actions.select_all, ["<C-d>"] = telescope_actions.drop_all, ["<Tab>"] = (telescope_actions.toggle_selection + telescope_actions.move_selection_better), ["<S-Tab>"] = (telescope_actions.toggle_selection + telescope_actions.move_selection_worse)}), border = false}, pickers = {buffers = {mappings = file_mappings, sort_lastused = true}, find_files = {mappings = file_mappings}, lsp_code_actions = merge({border = true}, telescope_themes.get_cursor()), live_grep = {mappings = grep_mappings}, grep_string = {mappings = grep_mappings}}, extensions = {["ui-select"] = merge({border = true}, telescope_themes.get_cursor())}})
telescope.load_extension("fzy_native")
telescope.load_extension("ui-select")
map_21({"n", "v"}, "<Leader>a", telescope_builtin.grep_string, {silent = true})
map_21({"n"}, "<Leader>f", telescope_builtin.live_grep, {silent = true})
map_21({"n"}, "<Leader>k", vim.lsp.buf.code_action, {silent = true})
map_21({"n"}, "<Leader>t", telescope_builtin.buffers, {silent = true})
return map_21({"n"}, "<Leader>T", telescope_builtin.find_files, {silent = true})
