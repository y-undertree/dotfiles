return {
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    init = function()
      require("core.utils").lazy_load "telescope-live-grep-args.nvim"
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
}