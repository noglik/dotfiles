require'nvim-treesitter.configs'.setup {
  ensure_installed = {'vim', 'lua', 'go', 'python'}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = true,
  }
}

