return {
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xq",
				"<cmd>Trouble quickfix toggle win.position=bottom win.size=0.2<cr>",
				desc = "[q]uickfix list",
			},
			{
				"<leader>xd",
				"<cmd>Trouble symbols toggle win.size=0.3 win.position=right<cr>",
				desc = "[d]ocument symbols",
			},
			{
				"<leader>xw",
				"<cmd>Trouble diagnostics toggle focus=true win.type=float<cr>",
				desc = "[w]orkspace diagnostics",
			},
			{
				"<leader>xl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "[l]SP mode",
			},
			{
				"<leader>gR",
				"<cmd>Trouble lsp_references<cr>",
				desc = "LSP references",
			},
		},
	},
}
