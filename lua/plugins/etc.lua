return {
	{ "nvim-lua/plenary.nvim" },

	{ "guns/vim-sexp" },
	{ "tpope/vim-sexp-mappings-for-regular-people" },
	{ "tpope/vim-repeat" },

	-- Jack in to REPL from nvim
	{ "tpope/vim-dispatch" },
	{ "clojure-vim/vim-jack-in" },
	{ "radenling/vim-dispatch-neovim" },

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
		},
	},
}
