-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.2',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              icons = false,
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
          }
      end
  })

 use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
 use('nvim-treesitter/playground')
 use 'nvim-lua/plenary.nvim'
 use {
     "ThePrimeagen/harpoon",
     branch = "harpoon2",
     requires = { {"nvim-lua/plenary.nvim"} }
 }

 use('mbbill/undotree')
 use('tpope/vim-fugitive')

 use {
	 'VonHeikemen/lsp-zero.nvim',
	 branch = 'v2.x',
	 requires = {
		 -- LSP Support
		 {'neovim/nvim-lspconfig'},             -- Required
		 {'williamboman/mason.nvim'},           -- Optional
		 {'williamboman/mason-lspconfig.nvim'}, -- Optional

		 -- Autocompletion
		 {'hrsh7th/nvim-cmp'},     -- Required
		 {'hrsh7th/cmp-nvim-lsp'}, -- Required
		 {'L3MON4D3/LuaSnip'},     -- Required
	 }
 }

 use 'nvim-tree/nvim-web-devicons' -- OPTIONAL: for file icons
 use 'lewis6991/gitsigns.nvim' -- OPTIONAL: for git status
 use 'romgrk/barbar.nvim'

 use 'Olical/conjure'
 use 'PaterJason/cmp-conjure'

 use {
     "folke/which-key.nvim",
     config = function()
         vim.o.timeout = true
         vim.o.timeoutlen = 300
         require("which-key").setup {
             -- your configuration comes here
             -- or leave it empty to use the default settings
             -- refer to the configuration section below
         }
     end
 }

 use 'guns/vim-sexp'
 use 'tpope/vim-sexp-mappings-for-regular-people'
 use 'tpope/vim-surround'
 use 'tpope/vim-repeat'
 use 'feline-nvim/feline.nvim'
 use 'EdenEast/nightfox.nvim'

 use 'tpope/vim-dispatch'
 use 'clojure-vim/vim-jack-in'
 use 'radenling/vim-dispatch-neovim'

 use 'julienvincent/nvim-paredit'
 use 'ggandor/leap.nvim'
 use 'tpope/vim-obsession'

end)
