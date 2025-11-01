-- [nfnl] fnl/local/utils.fnl
local get_line_number = vim.fn.line
local get_col_number = vim.fn.col
local syn_id = vim.fn.synID
local syn_id_attr = vim.fn.synIDattr
local syn_id_trans = vim.fn.synIDtrans
local popen = io.popen
local function system(cmd)
  local handle = popen((cmd .. " 2>&1"))
  local result = handle:read("*all")
  handle.close()
  return result
end
local function inspect_syntax_group()
  local line_number = get_line_number(".")
  local col_number = get_col_number(".")
  return ("hi<" .. syn_id_attr(syn_id(line_number, col_number, 1), "name") .. "> trans<" .. syn_id_attr(syn_id(line_number, col_number, 0), "name") .. "> lo<" .. syn_id_attr(syn_id_trans(syn_id(line_number, col_number, 1)), "name") .. ">")
end
return {system = system, ["inspect-syntax-group"] = inspect_syntax_group}
