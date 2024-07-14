return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
	  { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font }
	},
	config = function()
		require('telescope').setup {
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			-- defaults = {
			--   mappings = {
			--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
			--   },
			-- },
			-- pickers = {}
			extensions = {
			  ['ui-select'] = {
				require('telescope.themes').get_dropdown(),
			  },
			},
		}
		
		-- Enable Telescope extensions if they are installed
		pcall(require('telescope').load_extension, 'fzf')
		pcall(require('telescope').load_extension, 'ui-select')


		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc = 'Find [f]ile'})
		vim.keymap.set('n', '<C-g>', builtin.git_files, {})
		vim.keymap.set('n', '<leader>pg', builtin.live_grep, {desc = 'Live [g]rep'})
		vim.keymap.set('n', '<leader>ph', builtin.help_tags, {desc = 'Search [h]elp'})
		vim.keymap.set('n', '<leader>p?', builtin.oldfiles, {desc = '[?] Find recently opened files'})
		vim.keymap.set('n', '<leader>ps', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ")});
		end, {desc = 'Grep [s]tring'})

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set('n', '<leader>/', function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
			  winblend = 10,
			  previewer = false,
			})
		end, { desc = '[/] Fuzzily search in current buffer' })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set('n', '<leader>s/', function()
			builtin.live_grep {
			grep_open_files = true,
			prompt_title = 'Live Grep in Open Files',
			}
		end, { desc = '[S]earch [/] in Open Files' })
	end,
}

