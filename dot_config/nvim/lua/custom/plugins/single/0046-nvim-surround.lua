return {
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
  },
}