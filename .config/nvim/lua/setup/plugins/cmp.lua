local cmp = require('cmp')

local config = {
  mapping = cmp.mapping.preset.insert({
    ['<cr>'] = cmp.mapping.confirm({ select = false }),
    ['<c-space>'] = cmp.mapping.complete(),
    ['<tab>'] = cmp.mapping.select_next_item(),
    ['<s-tab>'] = cmp.mapping.select_next_item(),
    ['<c-j>'] = cmp.mapping.select_next_item(),
    ['<c-k>'] = cmp.mapping.select_prev_item(),
  })
}

cmp.setup(config)
