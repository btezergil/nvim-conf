return {
    {
        "chrisgrieser/nvim-tinygit",
        config = function()
            local tinygit = require("tinygit")
            vim.keymap.set("n", "gs", function()
                tinygit.interactiveStaging()
            end, { desc = "Tinygit: [g]it interactive [s]taging" })
            vim.keymap.set("n", "ga", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Tinygit: [g]it [a]dd hunk" }) -- gitsigns.nvim
            vim.keymap.set("n", "gc", function()
                tinygit.smartCommit()
            end, { desc = "Tinygit: [g]it [c]ommit" })
            vim.keymap.set("n", "gp", function()
                tinygit.push()
            end, { desc = "Tinygit: [g]it [p]ush" })
            vim.keymap.set("n", "gA", function()
                tinygit.amendNoEdit({ forcePushIfDiverged = true })
            end, { desc = "Tinygit: [g]it [A]mend" })
            vim.keymap.set("n", "gh", function()
                tinygit.fileHistory()
            end, { desc = "Tinygit: [g]it file [h]istory" })
        end,
    },
}
