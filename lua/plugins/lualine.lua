return {
	{
		"EdenEast/nightfox.nvim",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.cmd("colorscheme nightfox")
			require("lualine").setup({ extensions = { "lazy", "mason", "man", "trouble" } })
		end,
	},
}
