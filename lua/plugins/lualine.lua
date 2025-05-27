return {
    {
        "EdenEast/nightfox.nvim",
    },
    {
        "linrongbin16/lsp-progress.nvim",
        config = function()
            require("lsp-progress").setup()
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.cmd("colorscheme nightfox")
            require("lualine").setup({
                extensions = { "lazy", "mason", "man", "trouble" },
                sections = {
                    lualine_c = {
                        {
                            function()
                                return require("lsp-progress").progress()
                            end,
                        },
                        {
                            function()
                                local linters = require("lint").get_running()
                                if #linters == 0 then
                                    return "󰦕"
                                end
                                return "󱉶 " .. table.concat(linters, ", ")
                            end,
                        },
                    },
                },
            })

            -- listen lsp-progress event and refresh lualine
            vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
            vim.api.nvim_create_autocmd("User", {
                group = "lualine_augroup",
                pattern = "LspProgressStatusUpdated",
                callback = require("lualine").refresh,
            })
        end,
    },
}
