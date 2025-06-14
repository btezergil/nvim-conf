return {
	{
		"Olical/conjure",
		branch = "main",
		ft = { "clojure" }, -- etc
		lazy = true,
		event = "VeryLazy",
		init = function()
			-- Set configuration options here
			vim.g["conjure#debug"] = false
		end,
		config = function()
			vim.g["conjure#filetype#fennel"] = "conjure.client.fennel.stdio"
			vim.g["conjure#highlight#enabled"] = true
			vim.g["conjure#highlight#timeout"] = 150
			vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
			vim.g["conjure#client#clojure#nrepl#test#raw_out"] = true
			vim.g["conjure#client#clojure#nrepl#test#runner"] = "kaocha"
			vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
			vim.g["conjure#highlight#enabled"] = true
			vim.g["conjure#log#wrap"] = true
			vim.g["conjure#log#jump_to_latest#enabled"] = true
			vim.g["conjure#log#jump_to_latest#cursor_scroll_position"] = "top"
			vim.g["conjure#log#hud#enabled"] = false
			vim.g["conjure#mapping#log_split"] = false
			vim.g["conjure#mapping#log_vsplit"] = false
			vim.g["conjure#mapping#log_toggle"] = false
			vim.g["conjure#mapping#doc_word"] = false

			local function conjure_log_open(is_vertical)
				local log = require("conjure.log")
				log["close-visible"]()
				local cur_log
				if is_vertical then
					log.vsplit()
					local win = vim.api.nvim_get_current_win()
					vim.api.nvim_win_set_width(win, 50)
					cur_log = "vsplit"
				else
					log.split()
					local win = vim.api.nvim_get_current_win()
					vim.api.nvim_win_set_height(win, 16)
					cur_log = "split"
				end
				log["last-open-cmd"] = cur_log
			end

			local function is_log_win_open()
				local l = require("conjure.log")
				local wins = l["aniseed/locals"]["find-windows"]()
				for _, _ in pairs(wins) do
					return true
				end
				return false
			end

			local function conjure_log_toggle()
				local log = require("conjure.log")
				log.toggle()
				if is_log_win_open() and log["last-open-cmd"] == "split" then
					local win = vim.api.nvim_get_current_win()
					vim.api.nvim_win_set_height(win, 16)
				end
			end

			local wk = require("which-key")
			wk.add({
				{ "<localleader>e", group = "Evaluate" },
				{ "<localleader>ec", group = "To Comment" },
				{ "<localleader>ei", group = "Interrupt Eval" },
				{ "<localleader>c", group = "Connect" },
				{ "<localleader>g", desc = "Go to" },
				{ "<localleader>l", group = "Conjure Log" },
				{
					"<localleader>lg",
					function()
						conjure_log_toggle()
					end,
					desc = "Toggle",
				},
				{
					"<localleader>ls",
					function()
						conjure_log_open(false)
					end,
					desc = "Open Split",
				},
				{
					"<localleader>lv",
					function()
						conjure_log_open(true)
					end,
					desc = "Open VSplit",
				},
				{ "<localleader>r", desc = "Refresh" },
				{ "<localleader>s", desc = "Session" },
				{ "<localleader>t", desc = "Tests" },
				{ "<localleader>v", desc = "Display" },
				{ "<localleader>?", desc = "Convolute" },
				{ "<localleader>@", desc = "Splice List" },

				{ "<localleader>i", desc = "Round Head Wrap List" },
				{ "<localleader>I", desc = "Round Tail Wrap List" },
				{ "<localleader>[", desc = "Square Head Wrap List" },
				{ "<localleader>]", desc = "Square Tail Wrap List" },
				{ "<localleader>{", desc = "Curly Head Wrap List" },
				{ "<localleader>}", desc = "Curly Tail Wrap List" },

				{ "<localleader>h", desc = "Insert at List Head" },
				{ "<localleader>l", desc = "Insert at List Tail" },
				{ "<localleader>o", desc = "Raise List" },
				{ "<localleader>O", desc = "Raise Element" },

				{ "<localleader>w", desc = "Round Head Wrap Element" },
				{ "<localleader>W", desc = "Round Tail Wrap Element" },
				{ "<localleader>e[", desc = "Square Head Wrap Element" },
				{ "<localleader>e]", desc = "Square Tail Wrap Element" },
				{ "<localleader>e{", desc = "Curly Head Wrap Element" },
				{ "<localleader>e}", desc = "Curly Tail Wrap Element" },

				{ "<localleader>>)", desc = "Slurp forwards" },
				{ "<localleader>>(", desc = "Slurp backwards" },
				{ "<localleader><)", desc = "Barf forwards" },
				{ "<localleader><(", desc = "Barf backwards" },

				{ "<localleader>>e", desc = "Drag element right" },
				{ "<localleader><e", desc = "Drag element left" },
				{ "<localleader>>f", desc = "Drag form right" },
				{ "<localleader><f", desc = "Drag form left" },

				{ "[", desc = "Go to previous close bracket" },
				{ "]", desc = "Go to next open bracket" },
				{ "<M-e>", desc = "Go to next element tail" },
				{ "<M-b>", desc = "Go to previous element head" },
				{ "<M-w>", desc = "Go to next element head" },
				{ "<M-E>", desc = "Go to next tail" },
				{ "<M-B>", desc = "Go to previous head" },
				{ "<M-W>", desc = "Go to next head" },
			})
		end,

		-- Optional cmp-conjure integration
		dependencies = { "PaterJason/cmp-conjure" },
	},
	{
		"PaterJason/cmp-conjure",
		lazy = true,
		event = "VeryLazy",
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, { name = "conjure" })
			return cmp.setup(config)
		end,
	},
}
