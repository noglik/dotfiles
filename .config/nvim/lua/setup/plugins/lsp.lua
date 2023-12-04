local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gd', "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", opts)
  buf_set_keymap('n', 'gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap('n', 'gF', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
end)

lsp.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  server = {
    ['lua_ls'] = {'lua'},
    ['vimls'] = {'vim'},
    ['rust_analyzer'] = {'rust'},
    ['gopls'] = {'gopls'},
    ['tsserver'] = {'typescript', 'javascript'},
    ['eslint'] = {'eslint'},
  }
})

local signs = { error = '✘', warn = '▲', hint = '⚑', info = '' }
lsp.set_sign_icons(signs)

lsp.setup()

-- local lsp = require('lspconfig')
-- local cmp = require('cmp')
--
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       vim.fn["vsnip#anonymous"](args.body)
--     end,
--   },
--   mapping = {
--     ['<tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--     ['<s-tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--     ['<c-j>'] = cmp.mapping.select_next_item(),
--     ['<c-k>'] = cmp.mapping.select_prev_item(),
--     ['<c-space>'] = cmp.mapping.complete(),
--     ['<cr>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
--   },
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--     { name = 'vsnip' },
--   }, {
--     name = 'buffer'
--   }
--   )
-- })
--
-- local signs = { Error = '✘ ', Warn = '▲ ', Hint = '⚑ ', Info = ' ' }
-- for type, icon in pairs(signs) do
--   local hl = 'DiagnosticSign' .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end
--
-- vim.lsp.handlers['textDocument/publishDiagnostics'] =
-- vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics,
--   {
--     virtual_text = {
--       source = 'always',
--       prefix = '»',
--       spacing = 4,
--     },
--     signs = false,
--     update_in_insert = true,
--     severity_sort = true
--   }
-- )
--
--
-- -- codelens
-- local function code_lens_refresh(client)
--   if client.resolved_capabilities.code_lens then
--     vim.api.nvim_exec(
--       [[
--         augroup lsp_code_lens_refresh
--           autocmd! * <buffer>
--           autocmd InsertLeave <buffer> lua vim.lsp.codelens.refresh()
--           autocmd InsertLeave <buffer> lua vim.lsp.codelens.display()
--         augroup END
--       ]],
--       false
--     )
--   end
-- end
--
-- -- auto format
-- local function autoformat(client)
--   if client.server_capabilities.documentFormattingProvider then
--     vim.cmd(
--       [[
--         augroup LspFormatting
-- 	        autocmd! * <buffer>
-- 	        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
-- 	      augroup END
--       ]]
--     )
--   end
-- end
--
-- local on_attach = function(client, bufnr)
--   -- print(vim.inspect(client.server_capabilities))
--   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--
--   local opts = { noremap = true, silent = true }
--
--   buf_set_keymap('n', 'gd', "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", opts)
--   buf_set_keymap('n', 'gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", opts)
--   buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
--   buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
--   buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
--   buf_set_keymap('n', 'gF', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
--
--   -- enable code_lens
--   -- code_lens_refresh(client)
--   -- enable autoformat on save
--   autoformat(client)
-- end
--
-- -- load servers
-- require('mason-lspconfig').setup_handlers({
--   function(server_name)
--     local config = {
--       on_attach = on_attach,
--       flags = {
--         debounce_text_changes = 150,
--       },
--     }
--
--     lsp[server_name].setup(config)
--     if server_name == 'rust_analyzer' then
--       require('rust-tools').setup({
--         server = lsp[server_name]
--       })
--     end
--   end,
-- })
