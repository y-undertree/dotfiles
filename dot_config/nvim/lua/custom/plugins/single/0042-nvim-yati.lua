return {
  {
    "yioneko/nvim-yati",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      require("core.utils").lazy_load "nvim-yati"
    end,
  },
}