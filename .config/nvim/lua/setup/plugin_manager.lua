local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
  print('Installing lazy.nvim...')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- lates stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'navarasu/onedark.nvim',
    opts = {
      style = 'warmer',
      transparent = true,
      code_style = {
        comments = 'italic',
      },
      diagnostics = {
        undercurl = true
      }
    },
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.3',
    dependencies = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-file-browser.nvim'},
      {'nvim-telescope/telescope-ui-select.nvim'},
      {'kyazdani42/nvim-web-devicons'},
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },
  {
    'lewis6991/gitsigns.nvim',
  },
  {
    'christoomey/vim-tmux-navigator'
  },
})
