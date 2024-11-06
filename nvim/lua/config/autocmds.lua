vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile", "BufEnter" },
  { pattern = { "*.rnw" }, command = ":set filetype=tex" }
)

vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile", "BufEnter" },
  { pattern = { "*.tex", "*.rnw" }, command = ":set spelllang=en_us" }
)

vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile", "BufEnter" },
  { pattern = { "*.tex", "*.rnw" }, command = ":set spell" }
)

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, { command = ":silent! %foldclose!" })

-- {{{ my SpellCheck
function FileExists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local file_path = vim.fn.expand("%:p:h") .. "/spell.txt"
local file = io.open(file_path, "r")
if file then
  local contents = file:read("*l")
  file:close()

  contents = contents:match("^%s*(.-)%s*$")
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
    pattern = { "*.tex", "*.Rnw", "*.txt" },
    command = ":set spelllang=" .. contents,
  })
end
-- }}}
