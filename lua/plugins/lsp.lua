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
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"clojure_lsp",
				"lua_ls",
				"pyright",
				"jdtls",
				"dockerls",
				"pylint",
				"luacheck",
				"clj-kondo",
			},
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{
		"nvim-lua/lsp-status.nvim",
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				"hrsh7th/cmp-buffer", -- source for text in buffer
				"hrsh7th/cmp-path", -- source for file system paths
				"saadparwaiz1/cmp_luasnip", -- for autocompletion
			},
		},
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_cmp()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
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
					{ name = "buffer" },
					{ name = "path" },
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
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			local lsp_status = require("lsp-status")
			lsp_status.register_progress()

			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lsp_zero.set_preferences({
				suggest_lsp_servers = false,
				sign_icons = {
					error = "E",
					warn = "W",
					hint = "H",
					info = "I",
				},
			}) --[[

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
				lsp_status.on_attach(client)
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
				vim.keymap.set({ "n", "x" }, "<leader>vf", function()
					vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
				end, { desc = "[f]ormat code" })
			end)

			vim.diagnostic.config({
				virtual_text = true,
			})

			-- Infers the full executable path based on shell command name
			local read_exec_path = function(exec_name)
				local handle = io.popen("which " .. exec_name)
				local result = handle:read("*a"):gsub("\n", "")
				handle:close()
				return result
			end

			vim.lsp.config("clojure_lsp", {
				settings = {
					clojure_lsp = {
						java = {
							decompile_jar_as_project = true,
						},
					},
				},
			})

			vim.lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using (most
							-- likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
							-- Tell the language server how to find Lua modules same way as Neovim
							-- (see `:h lua-module-load`)
							path = {
								"lua/?.lua",
								"lua/?/init.lua",
							},
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths
								-- here.
								-- '${3rd}/luv/library'
								-- '${3rd}/busted/library'
							},
							-- Or pull in all of 'runtimepath'.
							-- NOTE: this is a lot slower and will cause issues when working on
							-- your own configuration.
							-- See https://github.com/neovim/nvim-lspconfig/issues/3189
							-- library = {
							--   vim.api.nvim_get_runtime_file('', true),
							-- }
						},
					})
				end,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})

			vim.lsp.config("pyright", {
				settings = {
					python = {
						pythonPath = read_exec_path("python"),
						venv = ".venv",
						venvPath = "./.venv/",
					},
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
			format_on_save = { timeout_ms = 5000, lsp_format = "fallback" },
			log_level = vim.log.levels.WARN,
		},
	},
}
