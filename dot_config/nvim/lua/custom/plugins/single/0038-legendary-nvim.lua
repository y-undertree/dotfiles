return {
  {
    "mrjones2014/legendary.nvim",
    event = "VeryLazy",
    config = function()
      local keymaps = {}
      for _, keymap in pairs(vim.api.nvim_get_keymap "n") do
        if keymap["desc"] then
          table.insert(keymaps, {
            keymap["lhs"],
            keymap["rhs"],
            description = keymap["desc"],
            opts = {
              silent = (keymap["silent"] == 1) and true or false,
              noremap = (keymap["noremap"] == 1) and true or false,
              nowait = (keymap["nowait"] == 1) and true or false,
              expr = (keymap["expr"] == 1) and true or false,
            }
          })
        end
      end
      require("legendary").setup {
        keymaps = keymaps,
        extensions = {
          smart_splits = {
            directions = { "h", "j", "k", "l" },
            mods = {
              move = "<C>",
              resize = false,
              swap = {
                mod = "<C>",
                prefix = "<leader>",
              },
            },
          },
        },
        default_item_formatter = function(item)
          local Toolbox = require "legendary.toolbox"
          local Config = require "legendary.config"
          if Toolbox.is_keymap(item) then
            return {
              Config.icons.keymap or table.concat(item --[[---@as Keymap]]:modes(), ", "),
              item.description,
              item.keys,
            }
          elseif Toolbox.is_command(item) then
            return {
              Config.icons.command,
              item.cmd,
              item.description,
            }
          elseif Toolbox.is_autocmd(item) then
            local pattern = vim.tbl_get(item, "opts", "pattern") or { "*" }
            if type(pattern) == "string" then
              pattern = { pattern }
            end
            return {
              table.concat(item.events, ", "),
              table.concat(pattern, ", "),
              item.description,
            }
          elseif Toolbox.is_function(item) then
            return {
              Config.icons.fn,
              "<function>",
              item.description,
            }
          elseif Toolbox.is_itemgroup(item) then
            return {
              item.icon or Config.icons.itemgroup,
              item.name,
              item.description or "Expand to select an item...",
            }
          else
            return {
              vim.inspect(item),
              "",
              "",
            }
          end
        end,
      }
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      "stevearc/dressing.nvim",
      "mrjones2014/smart-splits.nvim",
    },
  },
}