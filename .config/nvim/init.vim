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

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'kyazdani42/nvim-web-devicons'

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
noremap <leader>c :bd<cr>
nmap <c-c> :set hlsearch!<cr>
noremap <leader>p "+p
noremap <leader>y "+y

" ================================
" One Dark color scheme
lua <<EOF
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
EOF
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
          ['<c-j>'] = actions.move_selection_next,
          ['<c-k>'] = actions.move_selection_previous,
          ['<cr>'] = actions.select_default,
          ['<c-v>'] = actions.file_vsplit,
          ['<c-s>'] = actions.file_split,
          ['<c-t>'] = actions.file_tab,
          ['<c-?>'] = actions.which_key
        },
        n = {
          ['<esc>'] = actions.close,
          ['<cr>'] = actions.select_default,
          ['<v>'] = actions.file_vsplit,
          ['<s>'] = actions.file_split,
          ['<t>'] = actions.file_tab,
          ['<?>'] = actions.which_key,
        }
      }
    },
    pickers = {
      find_files = {
        find_command = {'rg', '--files', '--iglob', '!.git', '--hidden'}
      },
      buffers = {
        sort_lastused = true,
      }
    },
    extensions = {
      file_browser = {
        path = '%:p:h'
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {}
     }
    }
  }

  require('telescope').load_extension('file_browser')
  require('telescope').load_extension('ui-select')

  local opts = { noremap = true, silent = true }

  function project_files()
    local opts = {}
    local ok = pcall(require('telescope.builtin').git_files, opts)
    if not ok then require('telescope.builtin').find_files(opts) end
  end


  vim.api.nvim_set_keymap("n", "<leader>ft",  "<cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>", opts)
  vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua project_files()<cr>", opts)
  vim.api.nvim_set_keymap("n", "<leader><space>", "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)
  vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
  vim.api.nvim_set_keymap("n", "<leader>fs", "<cmd>lua require('telescope.builtin').git_status()<cr>", opts)

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

  
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  
    local opts = { noremap = true, silent = true }
  
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  end

  vim.o.updatetime = 250
  vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

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
          severity_sort = true
      }
    )

  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local servers = { 'tsserver', 'eslint', 'vimls', 'jsonls', 'rust_analyzer', 'gopls' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
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
  ensure_installed = {'vim', 'lua', 'typescript', 'rust'}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = {  }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {  },  -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
}
EOF
" ================================a
