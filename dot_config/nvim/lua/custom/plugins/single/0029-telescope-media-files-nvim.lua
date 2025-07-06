return {
  {
    "nvim-telescope/telescope-media-files.nvim",
    config = function()
      require("telescope").setup {
        extensions = {
          media_files = {
            find_cmd = "rg",
          },
        },
      }
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
}