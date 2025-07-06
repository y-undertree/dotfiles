return {
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup {
        preview = {
          wrap = true,
        },
      }
    end,
  },
}