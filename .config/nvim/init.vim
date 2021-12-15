" Autoload plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))                                                                                           
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data').'/plugged')

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'christoomey/vim-tmux-navigator'

Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

" pretty things
Plug 'navarasu/onedark.nvim'

call plug#end() 

" ================================
" general settings
set nonumber
  \ nobackup noswapfile
  \ ignorecase smartcase
  \ expandtab tabstop=2 shiftwidth=2 softtabstop=2
  \ backspace=indent,eol,start
  \ hidden
  \ completeopt=menu,menuone,noselect
  \ timeoutlen=1000 ttimeoutlen=0
  \ encoding=UTF-8
let mapleader=" " | let maplocalleader=";"

" ================================
" usefull mappings
nmap <silent> <leader>rr :source $MYVIMRC<cr>
nmap <silent> <leader>c :bd<cr>
nmap <c-c> :set hlsearch!<cr>
noremap <leader>p "+p
noremap <leader>y "+y

" ================================
" One Dark color scheme
let g:onedark_style = 'warmer'
let g:onedark_transparent_background = v:true
let g:onedark_italic_comment = v:true
colorscheme onedark

" ================================
" Telescope
lua <<EOF
  local telescope = require('telescope')
  local actions = require('telescope.actions')

  telescope.setup {
    defaults = {
      file_ignore_patterns = { 'node_modules' },
      sorting_strategy = 'ascending',
      layout_config = {
        prompt_position = 'top',
      },
      mappings = {
        i = {
          ['<esc>'] = actions.close,
          ['<c-j>'] = actions.move_selection_next,
          ['<c-k>'] = actions.move_selection_previous,
          ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
          ['<s-tab>'] = actions.toggle_selection + actions.move_selection_previous,
          ['<cr>'] = actions.select_default,
          ['<c-v>'] = actions.file_vsplit,
          ['<c-s>'] = actions.file_split,
          ['<c-t>'] = actions.file_tab
        },
        n = {
          ['<esc>'] = actions.close,
          ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
          ['<s-tab>'] = actions.toggle_selection + actions.move_selection_previous,
          ['<cr>'] = actions.select_default,
          ['<c-v>'] = actions.file_vsplit,
          ['<c-s>'] = actions.file_split,
          ['<c-t>'] = actions.file_tab
        }
      }
    },
    pickers = {
      find_files = {
        find_command = {'rg', '--files', '--iglob', '!.git', '--hidden'}
      }
    }
  }

  local keymap = {
    ff = 'find_files',
    fg = 'live_grep',
    fb = 'buffers',
    fs = 'git_status',
    ft = 'file_browser',
  }
  local opts = { noremap = true, silent = true }
  for key, builtin in pairs(keymap) do
    local command = '<cmd>lua require(\'telescope.builtin\').' .. builtin .. '()<cr>'
    vim.api.nvim_set_keymap('n', '<leader>' .. key, command, opts)
  end

EOF

" ================================
" Gitsigns
lua <<EOF
  require('gitsigns').setup {
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    keymaps = {
      noremap = true,
    }
  }
EOF

" ================================
" lsp + completion configuration
lua <<EOF
  local nvim_lsp = require('lspconfig')
  local cmp = require('cmp')
  
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<tab>'] = cmp.mapping.select_next_item(),
      ['<c-j>'] = cmp.mapping.select_next_item(),
      ['<c-k>'] = cmp.mapping.select_prev_item(),
      ['<c-space>'] = cmp.mapping.complete(),
      ['<cr>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
      }, {
        name = 'buffer'
      }
    )
  })
  
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  
    local opts = { noremap = true, silent = true }
  
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'ga', '<cmd>lua require(\'telescope.builtin\').lsp_code_actions(require(\'telescope.themes\').get_cursor())<CR>', opts)
  end

  vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      {
          virtual_text = {
            source = 'always',
            prefix = '»',
            spacing = 4,
          },
          signs = false,
          update_in_insert = true,
      }
    )

  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local servers = { 'tsserver', 'eslint', 'vimls' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end
EOF

" ================================
" treesitter module configuration
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"vim", "lua", "typescript"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = {  }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {  },  -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
}
EOF
" ================================

