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
                    lualine_x = {
                        "filetype",
                        {
                            require("noice").api.status.message.get_hl,
                            cond = require("noice").api.status.message.has,
                        },
                        {
                            require("noice").api.status.command.get,
                            cond = require("noice").api.status.command.has,
                            color = { fg = "#ff9e64" },
                        },
                        {
                            require("noice").api.status.mode.get,
                            cond = require("noice").api.status.mode.has,
                            color = { fg = "#ff9e64" },
                        },
                        {
                            require("noice").api.status.search.get,
                            cond = require("noice").api.status.search.has,
                            color = { fg = "#ff9e64" },
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
