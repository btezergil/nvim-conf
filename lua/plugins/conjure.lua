return {
  {
    "Olical/conjure",
    ft = { "clojure"}, -- etc
    lazy = true,
    event = 'VeryLazy',
    init = function()
      -- Set configuration options here
      vim.g["conjure#debug"] = false
    end,
    config = function()
      vim.g["conjure#filetype#fennel"] = "conjure.client.fennel.stdio"
      vim.g["conjure#mapping#doc_word"] = false
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#highlight#timeout"] = 150
      vim.g["conjure#log#wrap"] = true
      vim.g["conjure#log#jump_to_latest#enabled"] = false
      vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
      vim.g["conjure#client#clojure#nrepl#test#raw_out"] = true
      vim.g["conjure#client#clojure#nrepl#test#runner"] = "kaocha"
      vim.g["conjure#log#jump_to_latest#cursor_scroll_position"] = "none"
      vim.g["conjure#log#hud#enabled"] = false
      vim.g["conjure#mapping#log_split"] = false
      vim.g["conjure#mapping#log_vsplit"] = false
      vim.g["conjure#mapping#log_toggle"] = false

      --[[ local grp = vim.api.nvim_create_augroup("conjure_hooks", { clear = true })
      vim.api.nvim_create_autocmd("BufEnter", {
        group = grp,
        pattern = "conjure-log-*",
        callback = function(event)
          vim.diagnostic.disable(event.buf)
          for _, client in ipairs(vim.lsp.get_clients(  event.buf )) do
            vim.lsp.buf_detach_client(event.buf, client.id)
          end
        end,
      }) ]]

      local function connect_cmd()
        vim.api.nvim_feedkeys(":ConjureConnect localhost:", "n", false)
      end

      local function conjure_log_open(is_vertical)
        local log = require("conjure.log")
        log["close-visible"]()
        local cur_log
        if is_vertical then
          log.vsplit()
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_width(win, 50)
          cur_log = "vsplit"
        else
          log.split()
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_height(win, 16)
          cur_log = "split"
        end
        log["last-open-cmd"] = cur_log
      end

      local function is_log_win_open()
        local l = require("conjure.log")
        local wins = l["aniseed/locals"]["find-windows"]()
        for _, _ in pairs(wins) do
          return true
        end
        return false
      end

      local function conjure_log_toggle()
        local log = require("conjure.log")
        log.toggle()
        if is_log_win_open() and log["last-open-cmd"] == "split" then
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_height(win, 16)
        end
      end

      local wk = require("which-key")
      wk.add({
        { "<localleader>e", group = "Evaluate" },
        { "<localleader>e[", desc = "Square Head Wrap Element" },
        { "<localleader>e]", desc = "Square Tail Wrap Element" },
        { "<localleader>e{", desc = "Curly Head Wrap Element" },
        { "<localleader>e}", desc = "Curly Tail Wrap Element" },
        { "<localleader>ec", group = "To Comment" },
        { "<localleader>c", group = "Connect" },
        { "<localleader>g", desc = "Go to" },
        { "<localleader>l", group = "Conjure Log" },
        { "<localleader>lg", function() conjure_log_toggle() end, desc = "Toggle" },
        { "<localleader>ls", function() conjure_log_open(false) end, desc = "Open Split" },
        { "<localleader>lv", function() conjure_log_open(true) end, desc = "Open VSplit" },
        { "<localleader>r", desc = "Refresh" },
        { "<localleader>s", desc = "Session" },
        { "<localleader>t", desc = "Tests" },
        { "<localleader>v", desc = "Display" },
        { "<localleader>?", desc = "Convolute" },
        { "<localleader>@", desc = "Splice List" },
        { "<localleader>[", desc = "Square Head Wrap List" },
        { "<localleader>]", desc = "Square Tail Wrap List" },
        { "<localleader>{", desc = "Curly Head Wrap List" },
        { "<localleader>}", desc = "Curly Tail Wrap List" },
        { "<localleader>h", desc = "Insert at List Head" },
        { "<localleader>@", desc = "Splice List" },
        { "<localleader>i", desc = "Round Head Wrap List" },
        { "<localleader>I", desc = "Round Tail Wrap List" },
        { "<localleader>o", desc = "Raise List" },
        { "<localleader>O", desc = "Raise Element" },
        { "<localleader>w", desc = "Round Head Wrap Element" },
        { "<localleader>W", desc = "Round Tail Wrap Element" }
      })
    end,

    -- Optional cmp-conjure integration
    dependencies = { "PaterJason/cmp-conjure" },
  },
  {
    "PaterJason/cmp-conjure",
    lazy = true,
    event = 'VeryLazy',
    config = function()
      local cmp = require("cmp")
      local config = cmp.get_config()
      table.insert(config.sources, { name = "conjure" })
      return cmp.setup(config)
    end,
  }
}


  
