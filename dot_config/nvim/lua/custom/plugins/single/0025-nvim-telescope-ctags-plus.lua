return {
  {
    "gnfisher/nvim-telescope-ctags-plus",
    init = function()
      require("core.utils").lazy_load "nvim-telescope-ctags-plus"
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
}