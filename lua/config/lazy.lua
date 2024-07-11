-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setup lazy.nvim
require("lazy").setup({
    "nvim-lua/plenary.nvim",

    "guns/vim-sexp",
    "tpope/vim-sexp-mappings-for-regular-people",
    "tpope/vim-surround",
    "tpope/vim-repeat",

    -- Jack in to REPL from nvim
    "tpope/vim-dispatch",
    "clojure-vim/vim-jack-in",
    "radenling/vim-dispatch-neovim",
    
    "tpope/vim-obsession",
    
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "nightfox" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
