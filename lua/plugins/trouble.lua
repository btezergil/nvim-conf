return{
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
          icons = false,
      }
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", {silent = true, noremap = true, desc = 'Trouble [q]uickfix'})
      vim.keymap.set("n", "<leader>xx", function() require("trouble").open() end, {desc = 'Open Trouble'})
      vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end, {desc = '[w]orkspace diagnostics'})
      vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end, {desc = '[d]ocument diagnostics'})
      vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end, {desc = '[l]oclist'})
      vim.keymap.set("n", "gR", function() require("trouble").open("lsp_references") end, {desc = 'LSP references'})
    end,
  }
}
