return{
    {'romgrk/barbar.nvim',
        init = function() vim.g.barbar_auto_setup = true end,
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        opts = {
        },
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
        config = function()
            local map = vim.api.nvim_set_keymap
            local opts = { noremap = true, silent = true }

            -- Move to previous/next
            map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true , desc = 'Go to previous buffer'})
            map('n', '<A-.>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true , desc = 'Go to next buffer'})
            -- Re-order to previous/next
            map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', { noremap = true, silent = true , desc = 'Move buffer left'})
            map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', { noremap = true, silent = true , desc = 'Move buffer right'})
            -- Goto buffer in position...
            -- map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
            -- map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
            -- map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
            -- map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
            -- map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
            -- map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
            -- map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
            -- map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
            -- map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
            -- map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
            -- Pin/unpin buffer
            map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
            -- Close buffer
            map('n', '<A-c>', '<Cmd>BufferClose<CR>', { noremap = true, silent = true , desc = '[C]lose buffer'})
            -- Wipeout buffer
            --                 :BufferWipeout
            -- Close commands
            --                 :BufferCloseAllButCurrent
            --                 :BufferCloseAllButPinned
            --                 :BufferCloseAllButCurrentOrPinned
            --                 :BufferCloseBuffersLeft
            --                 :BufferCloseBuffersRight
            -- Magic buffer-picking mode
            map('n', '<C-p>', '<Cmd>BufferPick<CR>', { noremap = true, silent = true , desc = 'Buffer [p]icker'})
            -- Sort automatically by...
            map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
            map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
            map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
            map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
        end,
    },
}