return{
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open [g]it [s]creen"})
        -- TODO: fugitive icin toggle yapabilir miyiz?
    end
}

