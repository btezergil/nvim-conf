return {
    "rmagatti/auto-session",
    lazy = false,

    dependencies = {
        "nvim-telescope/telescope.nvim", -- Only needed if you want to use sesssion lens
    },
    keys = {
        -- Will use Telescope if installed or a vim.ui.select picker otherwise
        { "<C-s>", "<cmd>SessionSearch<CR>", desc = "Session search" },
    },

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        -- log_level = 'debug',
    },
}
