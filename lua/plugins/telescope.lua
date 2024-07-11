return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
	config = function()
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc = 'Find [f]ile'})
		vim.keymap.set('n', '<C-g>', builtin.git_files, {})
		vim.keymap.set('n', '<leader>pg', builtin.live_grep, {desc = 'Live [g]rep'})
		vim.keymap.set('n', '<leader>ph', builtin.help_tags, {desc = 'Search [h]elp'})
		vim.keymap.set('n', '<leader>?', builtin.oldfiles, {desc = '[?] Find recently opened files'})
		vim.keymap.set('n', '<leader>ps', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ")});
		end, {desc = 'Grep [s]tring'})
	end,
}

