local require = require("noice.util.lazy")

local Format = require("noice.lsp.format")
local Util = require("noice.util")
local Docs = require("noice.lsp.docs")
local Diag = noice.lsp.diag

local function tableMerge(table1, table2, result)
	for _, v in ipairs(table1) do
		table.insert(result, v)
	end
	for _, v in ipairs(table2) do
		table.insert(result, v)
	end
end

local M = {}

function M.setup()
  vim.lsp.handlers["textDocument/hover"] = M.on_hover
end

function M.on_hover(_, result)
  if not (result and result.contents) then
    print("no result and contents")
    return
  end

  local hover_contents = {}

  local message = Docs.get("hover")

  local diagnostic = Diag.get_diagnostic(nil)
  if not vim.tbl_isempty(diagnostic) then
    print("diag")
    tableMerge(Format.format_markdown(diagnostic), {}, hover_contents)
  end

  print("result contents", vim.tbl_isempty(result.contents))
  tableMerge({}, result.contents, hover_contents)
  if not message:focus() then
    Format.format(message, hover_contents)
    if message:is_empty() then
      print("empty message")
      return
    end
    Docs.show(message)
  end
end
M.on_hover = Util.protect(M.on_hover)

return M
