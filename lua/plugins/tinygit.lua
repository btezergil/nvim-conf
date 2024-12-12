return {
	{
		"chrisgrieser/nvim-tinygit",
		dependencies = "stevearc/dressing.nvim",
		config = function()
			local tinygit = require("tinygit")
			vim.keymap.set("n", "gs", function()
				tinygit.interactiveStaging()
			end, { desc = "[g]it interactive [s]taging" })
			vim.keymap.set("n", "ga", "<cmd>Gitsigns stage_hunk<CR>", { desc = "[g]it [a]dd hunk" }) -- gitsigns.nvim
			vim.keymap.set("n", "gc", function()
				tinygit.smartCommit()
			end)
			vim.keymap.set("n", "gp", function()
				tinygit.push()
			end, { desc = "[g]it [p]ush" })
		end,
	},
}
