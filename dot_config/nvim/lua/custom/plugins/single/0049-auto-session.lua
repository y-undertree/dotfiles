return {
  {
    'rmagatti/auto-session',
    lazy = false,
    envet = "VeryLazy",
    dependencies = {
      { "nvim-telescope/telescope.nvim" }
    },
    config = function()
      vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,winpos,localoptions"
      require("auto-session").setup({
        log_level = "error",
        use_git_branch = true,
        suppressed_dirs = { '~/', '~/Downloads', '/' },
        auto_restore_last_session = false,
        session_lens = {
          path_display = { "shorten" },
          theme = "ivy",
          previewer = true,
        }
      })
    end
  },
}