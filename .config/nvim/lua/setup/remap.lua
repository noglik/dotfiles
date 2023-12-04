vim.g.mapleader = " "

vim.keymap.set('n', '<leader>rr', ':source $MYVIMRC<cr>')

vim.keymap.set('n', '<leader>c', ':bd<cr>')

-- copy/paste
vim.keymap.set('v', '<leader>p', [["+p]])
vim.keymap.set('v', '<leader>y', [["+y]])
