return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup {
        start_in_insert = false,
      }
      rspec_current_line = function(count, is_coverage)
        local linenr = vim.api.nvim_win_get_cursor(0)[1]
        coverage_prefix = is_coverage and "COVERAGE=true " or ""
        require("toggleterm").exec(
          coverage_prefix .. "bundle exec rspec " .. vim.fn.expand "%" .. ":" .. linenr .. ";beep", count)
      end
      rspec_current_file = function(count, is_coverage)
        coverage_prefix = is_coverage and "COVERAGE=true " or ""
        require("toggleterm").exec(coverage_prefix .. "bundle exec rspec " .. vim.fn.expand "%" .. ";beep", count)
      end

      vim.cmd [[command! -count=1 RspecCurrentLine lua rspec_current_line(<count>, false)]]
      vim.cmd [[command! -count=1 RspecCurrentFile lua rspec_current_file(<count>, false)]]
      vim.cmd [[command! -count=1 RspecCurrentLineCoverage lua rspec_current_line(<count>, true)]]
      vim.cmd [[command! -count=1 RspecCurrentFileCoverage lua rspec_current_file(<count>, true)]]
    end,
  },
}