return {
	{ "nvim-lua/plenary.nvim" },

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
	{
		"tris203/precognition.nvim",
		opts = {},
	},
}

