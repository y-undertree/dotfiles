return {
  {
    "RRethy/vim-illuminate",
    init = function()
      require("core.utils").lazy_load "vim-illuminate"
    end,
    config = function()
      require("illuminate").configure {
        providers = {
          "treesitter",
          "regex",
          "lsp",
        },
        large_file_cutoff = 1000,
        min_count_to_highlight = 1,
        filetypes_denylist = {
          "telescope",
          "quickfix",
          "nvim-tree",
        },
      }
    end,
  },
}