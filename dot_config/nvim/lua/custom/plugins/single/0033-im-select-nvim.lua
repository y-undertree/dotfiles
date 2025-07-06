return {
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    config = function()
      require("im_select").setup {
        default_im_select = "com.apple.keylayout.ABC",
        default_command = "/usr/local/bin/im-select",
        set_default_events = { "InsertLeave", "CmdlineLeave" },
        set_previous_events = {},
      }
    end,
  },
}