return {
  {
    "axkirillov/easypick.nvim",
    init = function()
      require("core.utils").lazy_load "easypick.nvim"
    end,
    dependencies = "nvim-telescope/telescope.nvim",
    config = function()
      local easypick = require "easypick"
      local base_branch = "develop"
      easypick.setup {
        pickers = {
          {
            name = "ls",
            command = "ls",
            previewer = easypick.previewers.default(),
          },
          {
            name = "changed_files_stage",
            command = "git diff --cached --name-only",
            previewer = easypick.previewers.file_diff(),
          },
          {
            name = "changed_files",
            command = "git diff --name-only HEAD",
            previewer = easypick.previewers.file_diff(),
          },
          {
            name = "changed_files_compare_base_branch",
            command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
            previewer = easypick.previewers.branch_diff { base_branch = base_branch },
          },
          {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff(),
          },
        },
      }
    end,
  },
}