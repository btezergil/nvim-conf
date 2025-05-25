return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "clojure_lsp",
                "lua_ls",
                "pyright",
                "jdtls",
                "dockerls",
            },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    { "nvim-lua/lsp-status.nvim" },
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
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-cmdline",
                "saadparwaiz1/cmp_luasnip", -- for autocompletion
                "neovim/nvim-lspconfig",
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
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-y>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
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

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })

            -- completion side effects
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    if client:supports_method("textDocument/completion") then
                        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
                    end
                end,
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
            local lsp_status = require("lsp-status")
            lsp_status.register_progress()

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }

                    local opts_with_desc = function(desc)
                        return { buffer = args.buf, desc = "LSP: " .. desc }
                    end

                    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                    vim.keymap.set({ "n", "x" }, "gq", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)

                    vim.keymap.set("n", "grt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                    vim.keymap.set("n", "grd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                    vim.keymap.set(
                        "n",
                        "gi",
                        require("telescope.builtin").lsp_implementations,
                        opts_with_desc("implementations")
                    )
                    vim.keymap.set(
                        "n",
                        "gre",
                        require("telescope.builtin").lsp_references,
                        opts_with_desc("references")
                    )
                    vim.keymap.set(
                        "n",
                        "grs",
                        require("telescope.builtin").lsp_document_symbols,
                        opts_with_desc("document symbols")
                    )
                    vim.keymap.set(
                        "n",
                        "grw",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        opts_with_desc("workspace symbols")
                    )

                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.keymap.set("n", "<leader>tih", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, opts_with_desc("[T]oggle [I]nlay [H]ints"))
                    end
                end,
            })

            -- Set up lspconfig.
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.diagnostic.config({ virtual_text = true })

            vim.lsp.config("lua_ls", { capabilities = capabilities })
            vim.lsp.enable("lua_ls")

            vim.lsp.config("clojure_lsp", {
                capabilities = capabilities,
                settings = {
                    clojure_lsp = {
                        java = {
                            decompile_jar_as_project = true,
                        },
                    },
                },
            })

            -- Infers the full executable path based on shell command name
            local read_exec_path = function(exec_name)
                local handle = io.popen("which " .. exec_name)
                local result = handle:read("*a"):gsub("\n", "")
                handle:close()
                return result
            end

            vim.lsp.config("pyright", {
                capabilities = capabilities,
                settings = {
                    python = {
                        pythonPath = read_exec_path("python"),
                        venv = ".venv",
                        venvPath = "./.venv/",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            })

            -- format on save
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    if client:supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                            end,
                        })
                    end
                end,
            })

            -- inlay hints
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    if client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                    end
                end,
            })

            -- highlight word
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    if client:supports_method("textDocument/documentHighlight") then
                        local autocmd = vim.api.nvim_create_autocmd
                        local augroup = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })

                        vim.api.nvim_clear_autocmds({ buffer = args.buf, group = augroup })

                        autocmd({ "CursorHold" }, {
                            group = augroup,
                            buffer = args.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        autocmd({ "CursorMoved" }, {
                            group = augroup,
                            buffer = args.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
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
