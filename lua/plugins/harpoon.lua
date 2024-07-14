return{
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim"},
    init = function()
        local harpoon = require("harpoon")
        harpoon:setup()
    end,
    -- DEFAULT CONF
    config = function()
        local harpoon = require("harpoon")
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open harpoon window" })
        vim.keymap.set("n", "<leader>a", function()  harpoon:list():add() end, { desc = "[a]dd to Harpoon list"})
        vim.keymap.set("n", "<A-1>", function() harpoon:list():select(1) end, { desc = "Harpoon: go to first buffer"})
        vim.keymap.set("n", "<A-2>", function() harpoon:list():select(2) end, { desc = "Harpoon: go to second buffer"})
        vim.keymap.set("n", "<A-3>", function() harpoon:list():select(3) end, { desc = "Harpoon: go to third buffer"})
        vim.keymap.set("n", "<A-4>", function() harpoon:list():select(4) end, { desc = "Harpoon: go to fourth buffer"})
    end 
}