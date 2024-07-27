return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_cmp()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()

			cmp.setup({
				formatting = lsp_zero.cmp_format({ details = true }),
				mapping = cmp.mapping.preset.insert({
					["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<Esc>"] = cmp.mapping.close(),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "cmp-conjure" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			lsp_zero.set_preferences({
				suggest_lsp_servers = false,
				sign_icons = {
					error = "E",
					warn = "W",
					hint = "H",
					info = "I",
				},
			})--[[ 

      lsp_zero.format_on_save({
        format_opts = {
          async = false,
          timeout_ms = 10000,
        },
        servers = {
          ['cljfmt'] = {'clojure'},
          ['black'] = {'python'},
          ['stylua'] = {'lua'}
        }
      })

      lsp_zero.setup_servers({'cljfmt', 'black', 'stylua'}) ]]

			--- if you want to know more about lsp-zero and mason.nvim
			--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				-- lsp_zero.default_keymaps({buffer = bufnr})
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[g]o to [d]efinition")
				map("gi", require("telescope.builtin").lsp_implementations, "[g]o to [i]mplementation")
				map("gr", require("telescope.builtin").lsp_references, "[g]o to [r]eferences")
				map("<leader>vds", require("telescope.builtin").lsp_document_symbols, "[d]ocument [s]ymbols")
				map("K", function()
					vim.lsp.buf.hover()
				end, "Hover Documentation")
				map("<leader>vws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")
				map("<leader>vca", function()
					vim.lsp.buf.code_action()
				end, "[c]ode [a]ction")
				map("<leader>vrn", function()
					vim.lsp.buf.rename()
				end, "[r]e[n]ame")
				-- diagnostics
				map("<leader>vdf", function()
					vim.diagnostic.open_float()
				end, "Open [d]iagnostic float")
				map("[d", function()
					vim.diagnostic.goto_next()
				end, "Next [d]iagnostic")
				map("]d", function()
					vim.diagnostic.goto_prev()
				end, "Previous [d]iagnostic")
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, { buffer = bufnr, desc = "LSP: open floating help" })

				-- The following autocommand is used to enable inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("<leader>tih", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[T]oggle [I]nlay [H]ints")
				end

				-- TODO: custom format nasil yapariz
				vim.keymap.set({ "n", "x" }, "gq", function()
					vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
				end, opts)
			end)

			vim.diagnostic.config({
				virtual_text = true,
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"clojure_lsp",
					"lua_ls",
					"pyright",
					"java_language_server",
					"dockerls",
				},
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				--clojure = { "zprint" },
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			log_level = vim.log.levels.WARN,
		},
	},
}
