return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = true,
	opts = {
		disable_filetype = { "TelescopePrompt", "vim" },
		enable_check_bracket_line = false,
		ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
	},
}
