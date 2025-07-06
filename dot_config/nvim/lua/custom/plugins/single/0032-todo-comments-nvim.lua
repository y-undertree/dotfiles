return {
  {
    "folke/todo-comments.nvim",
    init = function()
      require("core.utils").lazy_load "todo-comments.nvim"
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}