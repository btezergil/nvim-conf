return{
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        formatting = lsp_zero.cmp_format({details = true}),
        mapping = cmp.mapping.preset.insert({
          ["<S-Tab>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
          ["<Tab>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Esc>"] = cmp.mapping.close(),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, 
          { name = 'cmp-conjure' }  
        }, {
          { name = 'buffer' },
        })
      })
    end
  },
  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.set_preferences({
        suggest_lsp_servers = false,
        sign_icons = {
            error = 'E',
            warn = 'W',
            hint = 'H',
            info = 'I'
        }
      })

      lsp_zero.format_on_save({
        format_opts = {
          async = false,
          timeout_ms = 10000,
        },
        servers = {
          ['cljfmt'] = {'clojure'},
          ['black'] = {'python'},
          ['stylua'] = {'lua'}
        }
      })

      --- if you want to know more about lsp-zero and mason.nvim
      --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        -- lsp_zero.default_keymaps({buffer = bufnr})
        local opts = {buffer = bufnr, remap = false}

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {buffer = bufnr, remap = false, desc = '[g]o to [d]efinition'})
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, {buffer = bufnr, remap = false, desc = '[g]o to [i]mplementation'})
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, {buffer = bufnr, remap = false, desc = 'Hover Documentation'})
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, {buffer = bufnr, remap = false, desc = '[w]orkspace [s]ymbols'})
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, {buffer = bufnr, remap = false, desc = 'Next [d]iagnostic'})
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, {buffer = bufnr, remap = false, desc = 'Previous [d]iagnostic'})
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, {buffer = bufnr, remap = false, desc = '[c]ode [a]ction'})
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, {buffer = bufnr, remap = false, desc = '[g]o to [r]eferences'})
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, {buffer = bufnr, remap = false, desc = '[r]e[n]ame'})
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end)

      vim.diagnostic.config({
          virtual_text = true
      })

      require('mason-lspconfig').setup({
        ensure_installed = {
          -- Clojure
          'clojure_lsp',
          'clj-kondo',
          'cljfmt',
  
          -- Lua
          'lua_ls',
          'luacheck',
          'stylua',
  
          -- Python
          'pyright',
          'pylint',
          'black',
          
          'java_language_server',
          'dockerls'
        },
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        }
      })
    end
  }
}