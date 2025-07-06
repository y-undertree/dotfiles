return {
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup {
        move_cursor_same_row = true,
        cursor_follows_swapped_bufs = false,
      }
    end,
  },
}