return{
  "nvim-treesitter/nvim-treesitter",
  build = ':TSUpdate',
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = {  "java", "python", "clojure", "c", "lua", "vim", "vimdoc", "query" },
    
      incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<M-space>',
            node_incremental = '<M-space>',
            scope_incremental = '<M-s>',
            node_decremental = '<M-backspace>'
        },
      },
    
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
    
      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = false},
    })      
  end,
}
