local require = require("noice.util.lazy")

local Format = require("noice.lsp.format")
local Util = require("noice.util")
local Docs = require("noice.lsp.docs")

local M = {}

function M.setup()
  vim.lsp.handlers["textDocument/hover"] = M.on_hover
end

function M.on_hover(_, result)
  if not (result and result.contents) then
    return
  end

  local message = Docs.get("hover")

  if not message:focus() then
    Format.format(message, result.contents)
    if message:is_empty() then
      return
    end
    Docs.show(message)
  end
end
M.on_hover = Util.protect(M.on_hover)

return M
