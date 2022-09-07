require('base')
require('plugins')

local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end
local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end
vim.g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}
-- Now the '+' register will copy to system clipboard using OSC52
vim.keymap.set('v', 'y', '"+y')
vim.cmd([[colorscheme nord]])
