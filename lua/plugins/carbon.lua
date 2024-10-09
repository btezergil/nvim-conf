return {
	{
		"SidOfc/carbon.nvim",
		config = function()
			require("carbon").setup({})
		end,
		keys = {
			{
				"<leader>pl",
				"<cmd>ToggleSidebarCarbon<cr>",
				desc = "Open carbon on [l]eft split",
			},
			{
				"<leader>pe",
				"<cmd>Fcarbon<cr>",
				desc = "Open carbon on float",
			},
		},
	},
}
