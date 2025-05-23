return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				views = {
					cmdline_popup = {
						position = {
							row = 18,
							col = "50%",
						},
						size = {
							width = 60,
							height = "auto",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = 21,
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
				routes = {
					view = "notify",
					filter = { event = "msg_showmode" },
				},
			})

			vim.keymap.set("n", "<leader>nl", function()
				require("noice").cmd("last")
			end)

			vim.keymap.set("n", "<leader>nh", function()
				require("noice").cmd("history")
			end)

			vim.keymap.set("n", "<leader>np", function()
				require("noice").cmd("telescope")
			end)
		end,
	},
}
