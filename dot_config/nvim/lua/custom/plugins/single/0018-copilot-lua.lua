return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    enabled = true,
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = false,
        },
        panel = { enabled = false },
        filetypes = {
          yaml = true,
          markdown = true,
          help = true,
          gitcommit = true,
          gitrebase = true,
          hgcommit = true,
          svn = true,
          cvs = true,
          ["."] = true,
        },
      }
    end,
  },
}