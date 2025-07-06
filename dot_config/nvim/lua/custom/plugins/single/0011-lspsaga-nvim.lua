return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      vim.diagnostic.config { virtual_text = false }
      require("lspsaga").setup {
        finder = {
          right_width = 0.7,
          default = 'tyd+def+imp+ref',
          keys = {
            vsplit = 'v',
            split = 's',
            tabe = 't',
            tabnew = 'r'
          }
        },
        definition = {
          keys = {
            edit = 'o',
            vsplit = 'v',
            split = 's',
            tabe = 't'
          }
        },
        hover_doc = {
          open_link = 'wo',
        },
        symbol_in_winbar = {
          enable = false,
          folder_level = 7,
        },
        request_timeout = 5000,
        outline = {
          -- win_position = "left",
        },
        lightbulb = {
          virtual_text = false,
          debounce = 400,
        },
        diagnostic = {
          diagnostic_only_current = false,
        },
        code_action = {
          show_server_name = true,
          extend_gitsigns = true,
        },
      }
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
      { "neovim/nvim-lspconfig" },
    },
  },
}