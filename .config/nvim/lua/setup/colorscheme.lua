local one_dark = require('onedark')

one_dark.setup {
  style = 'warmer',
  transparent = true,
  code_style = {
    comments = 'italic',
  },
  diagnostics = {
    undercurl = true
  }
}

one_dark.load()

vim.opt.termguicolors = true
vim.cmd.colorscheme('onedark')
