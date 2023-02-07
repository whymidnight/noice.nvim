local require = require("noice.util.lazy")

local Format = require("noice.lsp.format")
local Util = require("noice.util")
local Docs = require("noice.lsp.docs")
local Diag = noice.lsp.diag


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
  local diagnostic_contents = {}
  if not vim.tbl_isempty(diagnostic) then
    print("diag")
    diagnostic_contents = Format.format_markdown(diagnostic)
  end

  local result_contents = {}
  if result.contents then
    print("result contents", result.contents)
    result_contents = Format.format_markdown(result.contents)
  end

  table.insert(hover_contents, diagnostic_contents)
  table.insert(hover_contents, result_contents)

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
