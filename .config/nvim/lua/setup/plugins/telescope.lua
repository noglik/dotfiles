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
      find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' }
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

vim.api.nvim_set_keymap("n", "<leader>ft", "<cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>",
  opts)
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua project_files()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader><space>", "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>fs", "<cmd>lua require('telescope.builtin').git_status()<cr>", opts)
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions<cr>", opts)
vim.api.nvim_set_keymap("n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations<cr>", opts)
