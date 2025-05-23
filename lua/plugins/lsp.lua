return {
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
                "hrsh7th/cmp-buffer",       -- source for text in buffer
                "hrsh7th/cmp-path",         -- source for file system paths
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
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            cmp.setup({
                --formatting = lsp_zero.cmp_format({ details = true }),
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

            -- completion side effects
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    if client:supports_method("textDocument/completion") then
                        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
                    end
                end,
            })

            -- single tab complete
            vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
            vim.opt.shortmess:append("c")

            local function tab_complete()
                if vim.fn.pumvisible() == 1 then
                    -- navigate to next item in completion menu
                    return "<Down>"
                end

                local c = vim.fn.col(".") - 1
                local is_whitespace = c == 0 or vim.fn.getline("."):sub(c, c):match("%s")

                if is_whitespace then
                    -- insert tab
                    return "<Tab>"
                end

                local lsp_completion = vim.bo.omnifunc == "v:lua.vim.lsp.omnifunc"

                if lsp_completion then
                    -- trigger lsp code completion
                    return "<C-x><C-o>"
                end

                -- suggest words in current buffer
                return "<C-x><C-n>"
            end

            local function tab_prev()
                if vim.fn.pumvisible() == 1 then
                    -- navigate to previous item in completion menu
                    return "<Up>"
                end
                -- insert tab
                return "<Tab>"
            end

            vim.keymap.set("i", "<Tab>", tab_complete, { expr = true })
            vim.keymap.set("i", "<S-Tab>", tab_prev, { expr = true })
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

                    vim.keymap.set("n", "<C-Space>", "<C-x><C-o>", opts)
                    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                    vim.keymap.set({ "n", "x" }, "gq", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)

                    vim.keymap.set("n", "grt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                    vim.keymap.set("n", "grd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)

                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
                    end

                    map("gi", require("telescope.builtin").lsp_implementations, "[g]o to [i]mplementation")
                    map("gre", require("telescope.builtin").lsp_references, "[g]o to [re]ferences")
                    map("grs", require("telescope.builtin").lsp_document_symbols, "document [s]ymbols")
                    map("grw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[w]orkspace symbols")
                end,
            })
            --[[
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                -- lsp_zero.default_keymaps({buffer = bufnr})
                lsp_status.on_attach(client)
                -- diagnostics

                -- The following autocommand is used to enable inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    map("<leader>tih", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, "[T]oggle [I]nlay [H]ints")
                end
            end)]]

            vim.diagnostic.config({ virtual_text = true })

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

                        diagnostics = {
                            globals = { "vim" },
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
                        },
                        completion = {
                            callSnippet = "Replace",
                        },
                    })
                end,
                root_markers = { ".luarc.json", ".luarc.jsonc" },
            })

            -- Infers the full executable path based on shell command name
            local read_exec_path = function(exec_name)
                local handle = io.popen("which " .. exec_name)
                local result = handle:read("*a"):gsub("\n", "")
                handle:close()
                return result
            end

            vim.lsp.config("pyright", {
                settings = {
                    python = {
                        pythonPath = read_exec_path("python"),
                        venv = ".venv",
                        venvPath = "./.venv/",
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
