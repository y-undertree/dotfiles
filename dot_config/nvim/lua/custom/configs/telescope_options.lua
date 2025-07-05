-- cSpell:disable
local actions = require "telescope.actions"
local lga_actions = require "telescope-live-grep-args.actions"
local open_with_trouble = require("trouble.sources.telescope").open

local options = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--vimgrep",
      "--smart-case",
      "--max-columns=1000",
      "--max-columns-preview",
      "--max-filesize=5M",
      "--engine=auto",
      "--crlf",
    },
    prompt_prefix = "   ",
    -- prompt_prefix = "",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "row",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
        preview_cutoff = 200,
      },
      vertical = {
        mirror = false,
      },
      width = 0.95,
      height = 0.95,
      preview_cutoff = 200,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { ".git/", "node_modules/", "vendor/bundle/" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { filename_first = true },
    winblend = 6,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = {
        ["q"] = require("telescope.actions").close,
        ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-w>"] = lga_actions.quote_prompt(),
        ["<C-p>"] = actions.to_fuzzy_refine,
        ["<C-t>"] = open_with_trouble,
        ["<C-h>"] = actions.preview_scrolling_left,
        ["<C-l>"] = actions.preview_scrolling_right,
        ["h"] = actions.results_scrolling_left,
        ["l"] = actions.results_scrolling_right,
      },
      i = {
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-w>"] = lga_actions.quote_prompt(),
      },
    },
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
    },
    history = {
      limit = 100,
    },
  },
  pickers = {
    buffers = {
      mappings = {
        n = {
          ["d"] = actions.delete_buffer,
        },
      },
    },
    git_files = {
      sort_lastused = true,
      show_untracked = true
    }
  },
  extensions_list = {
    "fzf",
    "themes",
    "terms",
    "ctags_plus",
    "live_grep_args",
    "telescope-alternate",
    "highlight-annotate",
    "session-lens",
    "media_files",
    "undo",
    "toggletasks",
    "macros",
    "smart_open",
    "chezmoi",
    "notify",
    "neoclip",
    "bookmarks",
  },
  extensions = {
    ["telescope-alternate"] = {
      -- https://github.com/otavioschwanck/telescope-alternate.nvim#how-to-use
      mappings = {
        {
          "app/services/(.*)_services/(.*).rb",
          {                                                      -- alternate from services to contracts / models
            { "app/controllers/**/*[1].rb", "Controller" },      -- Adding label to switch
            { "app/models/**/*[1].rb",      "Model",     true }, -- Ignore create entry (with true)
          },
        },
        -- https://github.com/otavioschwanck/telescope-alternate.nvim/blob/master/lua/telescope-alternate/presets.lua
        -- rails
        {
          "app/models/(.*).rb",
          {
            { "app/controllers/**/*[1:pluralize]_controller.rb", "Controller" },
            { "app/controllers/[1:pluralize]_controller.rb",     "Controller",        true },
            { "app/helpers/**/[1]_helper.rb",                    "Helper" },
            { "app/helpers/[1]_helper.rb",                       "Helper",            true },
            { "app/serializers/**/[1]_serializer.rb",            "Serializer" },
            { "app/serializers/[1]_serializer.rb",               "Serializer",        true },
            { "config/locales/**/model/[1].yml",                 "Locale" },
            { "config/locales/ja/model/[1].yml",                 "Locale",            true },
            { "spec/models/**/[1]_spec.rb",                      "Model Test" },
            { "spec/models/[1]_spec.rb",                         "Model Test",        true },
            { "spec/factories/**/[1:pluralize].rb",              "Factory Test Data" },
            { "spec/factories/[1:pluralize].rb",                 "Factory Test Data", true }
          },
        },
        {
          "app/controllers/(.*)/(.*)_controller.rb",
          {
            { "app/models/**/*[2:singularize].rb",       "Model" },
            { "app/views/[1]/[2]/*",                     "View" },
            { "app/views/[1]/[2]/index.html.erb",        "View",         true },
            { "docker/swagger/paths/**/[2].*",           "Swagger" },
            { "docker/swagger/paths/[1]/[2].yml",        "Swagger",      true },
            { "swagger/**/[2:singularize].*",            "Swagger" },
            { "swagger/[1]/[2:singularize].yaml",        "Swagger",      true },
            { "spec/requests/[1]/[2]/*_spec.rb",         "Request Test" },
            { "spec/requests/[1]/[2]_spec.rb",           "Request Test", true },
            { "app/services/[2:singularize]_service.rb", "ServiceClass", true },
          },
        },
        {
          "app/views/(.*)/(.*).html.(.*)",
          {
            { "app/controllers/**/*[1]_controller.rb", "Controller" },
          },
        },
        {
          "config/locales/(.*)/(.*)/(.*).yml",
          {
            { "app/[2:pluralize]/[3].rb", "Implementation" },
          },
        },
        {
          "spec/factories/(.*).rb",
          {
            { "app/models/**/*[1:singularize].rb", "Model" },
            { "app/models/[1:singularize].rb",     "Model", true },
          },
        },
        -- rspec
        { "app/(.*).rb",       { { "spec/[1]_spec.rb", "Test" } } },
        { "spec/(.*)_spec.rb", { { "app/[1].rb", "Original", true } } },
        {
          "spec/requests/(.*)/(.*)/(.*)_spec.rb",
          {
            { "app/controllers/[1]/[2]/[3]_controller.rb", "Original", true },
            { "app/controllers/[1]/[2]_controller.rb",     "Original", true }
          },
        }
      },
      -- presets = { "rails", "rspec" },
    },
    live_grep_args = {
      auto_quoting = false, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = {          -- extend mappings
        i = {
          ["<tab>"] = lga_actions.quote_prompt { postfix = " --iglob " },
          ["<C-x>"] = lga_actions.quote_prompt({ postfix = " --hidden **/* " }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    },
    smart_open = {
      match_algorithm = 'fzf',
    },
  },
}

return options
