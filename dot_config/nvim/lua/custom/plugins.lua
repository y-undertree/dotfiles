-- cSpell:disable
local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      }
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local default_opts = require "plugins.configs.treesitter"
      local opts = overrides.treesitter
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      local default_opts = require "plugins.configs.treesitter"
      local opts = overrides.gitsigns
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      local default_opts = require "plugins.configs.telescope"
      local opts = require "custom.configs.telescope_options"
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function()
      local default_opts = require "plugins.configs.cmp"
      local opts = require "custom.configs.cmp_options"
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)
      cmp.setup.filetype("DressingInput", {
        sources = cmp.config.sources { { name = "omni" } },
      })
    end,
  },
  {
    -- snippet plugin
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function(_, opts)
      require("luasnip").config.set_config(opts)

      vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/vscode"
      vim.g.vscode_standalone_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/vscode/all.code-snippets"
      vim.g.snipmate_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/snipmate"
      vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/lua"

      -- vscode format
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }
      require("luasnip.loaders.from_vscode").load_standalone { path = vim.g.vscode_standalone_snippets_path or "" }

      -- snipmate format
      require("luasnip.loaders.from_snipmate").load()
      require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

      -- lua format
      require("luasnip.loaders.from_lua").load()
      require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          if
              require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
              and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end,
      })
    end,
  },
  -- Install a plugin
  {
    "davidmh/cspell.nvim",
    dependencies = { "nvimtools/none-ls.nvim" },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      vim.diagnostic.config { virtual_text = false }
      require("lspsaga").setup {
        -- finder = {
        --   right_width = 0.7,
        --   default = 'ref+imp',
        --   keys = {
        --     vsplit = 'v',
        --     split = 's',
        --     tabe = 'r',
        --     tabnew = 't'
        --   }
        -- },
        -- definition = {
        --   keys = {
        --     edit = 'o',
        --     vsplit = 'v',
        --     split = 's',
        --     tabe = 't'
        --   }
        -- },
        hover_doc = {
          open_link = 'wo',
        },
        symbol_in_winbar = {
          enable = false,
          folder_level = 7,
        },
        request_timeout = 5000,
        outline = {
          -- win_position = "left",
        },
        lightbulb = {
          virtual_text = false,
          debounce = 400,
        },
        diagnostic = {
          diagnostic_only_current = false,
        },
        code_action = {
          show_server_name = true,
          extend_gitsigns = true,
        },
      }
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
      { "neovim/nvim-lspconfig" },
    },
  },
  {
    "dnlhc/glance.nvim",
    event = "VeryLazy",
    config = function()
      local glance = require('glance')
      local actions = glance.actions
      glance.setup({
        height = 25,
        detached = true,
        border = {
          enable = true,
          top_char = '―',
          bottom_char = '―',
        },
        list = {
          position = 'left',
          ['<leader>ll'] = actions.enter_win('preview'), -- Focus preview window
          ['<leader>lq'] = actions.quickfix,
        },
        preview = {
          ['<leader>ll'] = actions.enter_win('list'), -- Focus list window
        },
      })

      vim.cmd [[highlight GlanceListMatch guifg=#ffe396 guibg=NONE]]
      vim.cmd [[highlight GlancePreviewCursorLine guifg=#ffe396 guibg=NONE]]
      vim.cmd [[highlight GlancePreviewMatch guifg=NONE guibg=NONE]]
    end,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "phaazon/hop.nvim",
    keys = { "f", "F" },
    event = "VeryLazy",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
      local hop = require "hop"
      local directions = require("hop.hint").HintDirection
      vim.keymap.set("", "f", function()
        hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true }
      end, { remap = true })
      vim.keymap.set("", "F", function()
        hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true }
      end, { remap = true })
    end,
  },
  {
    'mfussenegger/nvim-treehopper',
    event = "VeryLazy",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "phaazon/hop.nvim" }, -- for curl, log wrapper
    },
  },
  {
    'echasnovski/mini.align',
    event = "VeryLazy",
    config = function()
      require("mini.align").setup()
    end,
  },
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  --   keys = {
  --     {
  --       "s",
  --       mode = { "n", "x" },
  --       function()
  --         require("flash").jump()
  --       end,
  --       desc = "Flash",
  --     },
  --     {
  --       "S",
  --       mode = { "n", "x" },
  --       function()
  --         require("flash").treesitter()
  --       end,
  --       desc = "Flash Treesitter",
  --     },
  --     -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --     -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --     -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   },
  -- },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup {
        start_in_insert = false,
      }
      -- rspec
      rspec_current_line = function(count)
        local linenr = vim.api.nvim_win_get_cursor(0)[1]
        require("toggleterm").exec("bundle exec rspec " .. vim.fn.expand "%" .. ":" .. linenr, count, 20)
      end
      rspec_current_file = function(count)
        require("toggleterm").exec("bundle exec rspec " .. vim.fn.expand "%", count, 20)
      end

      vim.cmd [[command! -count=1 RspecCurrentLine lua rspec_current_line(<count>)]]
      vim.cmd [[command! -count=1 RspecCurrentFile lua rspec_current_file(<count>)]]
    end,
  },
  {
    "mechatroner/rainbow_csv",
    ft = { "csv" },
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    enabled = true,
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = false,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-]>",
            accept_word = false,
            accept_line = false,
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-e>",
          },
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
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
    dependencies = { "hrsh7th/nvim-cmp" },
  },
  {
    "ray-x/cmp-treesitter",
    dependencies = { "hrsh7th/nvim-cmp" },
  },
  {
    "RRethy/vim-illuminate",
    init = function()
      require("core.utils").lazy_load "vim-illuminate"
    end,
    config = function()
      vim.g.Illuminate_highlightUnderCursor = 0
      require("illuminate").configure {
        providers = {
          "treesitter",
          "regex",
          "lsp",
        },
        -- providers_regex_syntax_allowlist = {
        --   "ruby",
        --   "lua",
        --   "markdown",
        --   "text",
        -- },
        min_count_to_highlight = 1,
        filetypes_denylist = {
          "telescope",
          "quickfix",
          "nvim-tree",
        },
      }
    end,
  },
  {
    "posva/vim-vue",
    ft = "vue",
  },
  {
    "otavioschwanck/telescope-alternate",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    'stevearc/oil.nvim',
    event = "VeryLazy",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "gnfisher/nvim-telescope-ctags-plus",
    init = function()
      require("core.utils").lazy_load "nvim-telescope-ctags-plus"
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "crispgm/telescope-heading.nvim",
    init = function()
      require("core.utils").lazy_load "telescope-heading.nvim"
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  -- {
  --   "prochri/telescope-all-recent.nvim",
  --   event = "VeryLazy",
  --   dependencies = { "kkharji/sqlite.lua", "nvim-telescope/telescope.nvim", "stevearc/dressing.nvim" },
  --   config = function()
  --     require("telescope-all-recent").setup {
  --       default = {
  --         disable = true, -- disable any unkown pickers (recommended)
  --         use_cwd = true, -- differentiate scoring for each picker based on cwd
  --         sorting = "frecency", -- sorting: options: 'recent' and 'frecency'
  --       },
  --       pickers = { -- allows you to overwrite the default settings for each picker
  --         man_pages = { -- enable man_pages picker. Disable cwd and use frecency sorting.
  --           disable = true,
  --           use_cwd = false,
  --           sorting = "frecency",
  --         },
  --       },
  --     }
  --   end,
  -- },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    dependencies = {
      "kkharji/sqlite.lua",
      { "nvim-telescope/telescope-fzf-native.nvim" },
    },
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    init = function()
      require("core.utils").lazy_load "telescope-live-grep-args.nvim"
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "nvim-telescope/telescope-smart-history.nvim",
    init = function()
      require("core.utils").lazy_load "telescope-smart-history.nvim"
    end,
    dependencies = { "kkharji/sqlite.lua", "nvim-telescope/telescope.nvim" },
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    config = function()
      require("telescope").setup {
        extensions = {
          media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            -- filetypes = {"png", "webp", "jpg", "jpeg"},
            -- find command (defaults to `fd`)
            find_cmd = "rg",
          },
        },
      }
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
  },
  {
    "axkirillov/easypick.nvim",
    init = function()
      require("core.utils").lazy_load "easypick.nvim"
    end,
    dependencies = "nvim-telescope/telescope.nvim",
    config = function()
      local easypick = require "easypick"

      -- only required for the example to work
      local base_branch = "develop"

      easypick.setup {
        pickers = {
          -- add your custom pickers here
          -- below you can find some examples of what those can look like

          -- list files inside current folder with default previewer
          {
            -- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
            name = "ls",
            -- the command to execute, output has to be a list of plain text entries
            command = "ls",
            -- specify your custom previwer, or use one of the easypick.previewers
            previewer = easypick.previewers.default(),
          },

          -- diff current branch with base_branch and show files that changed with respective diffs in preview
          {
            name = "changed_files",
            command = "git diff --name-only HEAD",
            previewer = easypick.previewers.file_diff(),
          },
          {
            name = "changed_files_compare_develop",
            command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
            previewer = easypick.previewers.branch_diff { base_branch = base_branch },
          },
          -- list files that have conflicts with diffs in preview
          {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff(),
          },
        },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    init = function()
      require("core.utils").lazy_load "todo-comments.nvim"
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    config = function()
      require("im_select").setup {
        default_im_select = "com.apple.keylayout.ABC",
        default_command = "im-select",
        set_default_events = { "InsertLeave", "CmdlineLeave" },
        set_previous_events = {},
      }
    end,
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup {
        move_cursor_same_row = true,
        cursor_follows_swapped_bufs = false,
      }
    end,
  },
  {
    "folke/which-key.nvim",
    -- TODO: Needs adjustment in v3. There are currently no problems.
    -- opts = overrides.whichkey,
    dependencies = {
      { "echasnovski/mini.nvim" },
      { "nvim-tree/nvim-web-devicons" },
    },
  },
  {
    "mrjones2014/legendary.nvim",
    event = "VeryLazy",
    config = function()
      local keymaps = {}
      for _, keymap in pairs(vim.api.nvim_get_keymap "n") do
        if keymap["desc"] then
          table.insert(keymaps, {
            keymap["lhs"],
            keymap["rhs"],
            description = keymap["desc"],
            opts = {
              silent = (keymap["silent"] == 1) and true or false,   -- use `silent` when creating keymaps
              noremap = (keymap["noremap"] == 1) and true or false, -- use `noremap` when creating keymaps
              nowait = (keymap["nowait"] == 1) and true or false,   -- use `nowait` when creating keymaps
              expr = (keymap["expr"] == 1) and true or false,       -- use `expr` when creating keymaps
            }
          })
        end
      end
      require("legendary").setup {
        keymaps = keymaps,
        extensions = {
          -- default settings shown below:
          smart_splits = {
            directions = { "h", "j", "k", "l" },
            mods = {
              -- for moving cursor between windows
              move = "<C>",
              -- for resizing windows
              resize = false,
              -- for swapping window buffers
              swap = {
                -- this will create the mapping like
                -- <leader><C-h>
                -- <leader><C-j>
                -- <leader><C-k>
                -- <leader><C-l>
                mod = "<C>",
                prefix = "<leader>",
              },
            },
          },
        },
        default_item_formatter = function(item)
          -- https://github.com/mrjones2014/legendary.nvim/blob/master/lua/legendary/ui/format.lua#L17
          local Toolbox = require "legendary.toolbox"
          local Config = require "legendary.config"

          if Toolbox.is_keymap(item) then
            return {
              Config.icons.keymap or table.concat(item --[[@as Keymap]]:modes(), ", "),
              item.description,
              item.keys,
            }
          elseif Toolbox.is_command(item) then
            return {
              Config.icons.command,
              item.cmd,
              item.description,
            }
          elseif Toolbox.is_autocmd(item) then
            local pattern = vim.tbl_get(item, "opts", "pattern") or { "*" }
            if type(pattern) == "string" then
              pattern = { pattern }
            end
            return {
              table.concat(item.events, ", "),
              table.concat(pattern, ", "),
              item.description,
            }
          elseif Toolbox.is_function(item) then
            return {
              Config.icons.fn,
              "<function>",
              item.description,
            }
          elseif Toolbox.is_itemgroup(item) then
            return {
              item.icon or Config.icons.itemgroup,
              item.name,
              item.description or "Expand to select an item...",
            }
          else
            -- unreachable
            return {
              vim.inspect(item),
              "",
              "",
            }
          end
        end,
      }
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      "stevearc/dressing.nvim",
      "mrjones2014/smart-splits.nvim",
    },
  },
  {
    "ntpeters/vim-better-whitespace",
    keys = "<C-s>",
    cmd = "ToggleWhitespace",
  },
  {
    "slim-template/vim-slim",
    ft = "slim",
  },
  -- partial jumpの関係で必要
  {
    "tpope/vim-rails",
    lazy = false,
  },
  {
    "RRethy/nvim-treesitter-endwise",
    lazy = false,
    -- init = function()
    --   require("core.utils").lazy_load "nvim-treesitter-endwise"
    -- end,
  },
  {
    "yioneko/nvim-yati",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      require("core.utils").lazy_load "nvim-yati"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup {
        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 5,            -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20,     -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  },
  {
    "haringsrob/nvim_context_vt",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      require("core.utils").lazy_load "nvim_context_vt"
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy"
  },
  {
    "AndrewRadev/linediff.vim",
    cmd = "Linediff",
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
  },
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
  {
    "tyru/open-browser.vim",
    init = function()
      require("core.utils").lazy_load "open-browser.vim"
    end,
  },
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
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_use_git_branch = true,
        session_lens = {
          path_display = { "shorten" },
          theme = "ivy", -- default is dropdown
          previewer = true,
        }
      })
    end
  },
  {
    "nicwest/vim-camelsnek",
    event = "CmdlineEnter",
  },
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    config = function()
      require("git-conflict").setup()
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.notify("Conflict detected in " .. vim.fn.expand "<afile>")
          vim.keymap.set("n", "cww", function()
            engage.conflict_buster()
            create_buffer_local_mappings()
          end)
        end,
      })
    end,
  },
  {
    "rhysd/committia.vim",
    lazy = false,
    ft = "gitcommit",
    -- init = function()
    --   require("core.utils").lazy_load "committia.vim"
    -- end,
  },
  {
    "hotwatermorning/auto-git-diff",
    lazy = false,
    ft = "gitrebase",
    -- init = function()
    --   require("core.utils").lazy_load "auto-git-diff"
    -- end,
  },
  {
    "knsh14/vim-github-link",
    cmd = "GetCommitLink",
  },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = true,
  },
  {
    "folke/neodev.nvim",
    ft = "lua",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("neodev").setup {}
    end,
  },
  {
    "bfredl/nvim-luadev",
    cmd = "Luadev",
  },
  {
    "tomasky/bookmarks.nvim",
    event = "VimEnter",
    config = function()
      local current_dir = vim.fn.getcwd()
      local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):match("^%s*(.-)%s*$")
      if current_branch == nil or current_branch == '' then
        current_branch = "bookmarks"
      end
      local bookmark_paths = { "$HOME", ".bookmarks", current_dir }
      local bookmark_dir = table.concat(bookmark_paths, "/")
      local command = "mkdir -p " .. bookmark_dir
      local result = os.execute(command)

      if result then
        vim.notify("Folder created successfully.", vim.log.levels.INFO)
      else
        vim.notify("Failed to create folder.", vim.log.levels.ERROR)
      end
      require("bookmarks").setup {
        save_file = vim.fn.expand(bookmark_dir .. "/" .. current_branch),
        keywords = {
          ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
          ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
          ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
          ["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
        },
      }
    end,
  },
  {
    -- global file bookmarks
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        }):find()
      end

      vim.keymap.set("n", "<leader>hs", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "add file harpoon" })
      vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "harpoon menu" })
    end,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" }
  },
  {
    "ivyl/highlight-annotate.nvim",
    init = function()
      require("core.utils").lazy_load "highlight-annotate.nvim"
    end,
    config = function()
      require("highlight-annotate").setup {}
      -- require("core.utils").lazy_load "highlight-annotate"
    end,
  },
  -- debugger
  {
    "mfussenegger/nvim-dap",
    keys = { "<leader>dbt" },
    config = function()
      local dap = require "dap"
      -- lua debugger
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }
      dap.adapters.nlua = function(callback, config)
        callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
      end
      -- ruby
      dap.adapters.ruby = function(callback, config)
        callback {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "bundle",
            args = {
              "exec",
              "rdbg",
              "--nonstop",
              "--open",
              "--port",
              "${port}",
              "--command",
              "--",
              "bundle",
              "exec",
              config.command,
              config.script,
            },
          },
        }
      end

      dap.configurations.ruby = {
        {
          type = "ruby",
          name = "debug current file",
          request = "attach",
          localfs = true,
          command = "ruby",
          script = "${file}",
        },
        {
          type = "ruby",
          name = "run current spec file",
          request = "attach",
          localfs = true,
          command = "rspec",
          script = "${file}",
        },
        {
          -- domian socketだとconnectできないときがあるので、portにて対応
          -- bundle exec rdbg --open --port 12345 --nonstop --command -- bin/rails server
          type = "rdbg",
          name = "rails debugger by rdbg",
          request = "attach",
          localfs = true,
          debugPort = "127.0.0.1:12345",
          command = "rails",
          script = "server",
        },
      }
    end,
  },
  {
    "suketa/nvim-dap-ruby",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-ruby").setup()
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "kchmck/vim-coffee-script",
    ft = { "coffee" },
  },
  -- {
  --   "iberianpig/tig-explorer.vim",
  --   cmd = { "TigBlame", "TigStatus" },
  -- },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    envet = "VeryLazy",
    config = function()
      require("blame").setup({
        date_format = "%Y-%m-%d",
        virtual_style = "right",
        merge_consecutive = false,
        max_summary_width = 50,
        commit_detail_view = "vsplit",
        mappings = {
          commit_info = "i",
          stack_push = ",",
          stack_pop = "<",
          show_commit = "<CR>",
          close = { "<esc>", "q" },
        }
      })
      -- git find-pr
      vim.api.nvim_create_user_command("OpenGithubPr", function()
        local line = vim.api.nvim_get_current_line()

        local commit_id = line:match("commit%s*(%w+)")
        if not commit_id then
          print("No commit ID found on the current line")
          return
        end

        local command = "git pr-find " .. commit_id
        local handle = io.popen(command, 'r')
        handle:close()
      end, {})
    end
  },
  {
    "kevinhwang91/nvim-hlslens",
    lazy = false,
    dependencies = { "rapan931/lasterisk.nvim" },
    config = function()
      require("hlslens").setup()
      require("scrollbar.handlers.search").setup({})
      local kopts = { noremap = true, silent = true }

      vim.api.nvim_set_keymap(
        "n",
        "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
      vim.api.nvim_set_keymap(
        "n",
        "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
      vim.keymap.set("n", "*", function()
        require("lasterisk").search()
        require("hlslens").start()
      end)

      vim.keymap.set({ "n", "x" }, "g*", function()
        require("lasterisk").search { is_whole = false }
        require("hlslens").start()
      end)

      vim.cmd [[highlight HlSearchNear guifg=#0c171b guibg=#ecd28b]]
      vim.cmd [[highlight HlSearchLens guifg=#0c171b guibg=#e9967e]]
      vim.cmd [[highlight HlSearchLensNear guifg=#0c171b guibg=#ecd28b]]
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
      require("ufo").setup {
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = { "imports", "comment" },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
      }
    end,
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialNavToggle" },
    config = function()
      require("aerial").setup {
        autojump = true,
        nav = {
          -- Jump to symbol in source window when the cursor moves
          -- autojump = true,
          -- Show a preview of the code in the right column, when there are no child symbols
          preview = true,
        },
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  -- 動作は好きだがよく落ちるので
  -- {
  --   "declancm/cinnamon.nvim",
  --   lazy = false,
  --   config = function()
  --     require("cinnamon").setup {
  --       extra_keymaps = false,
  --       extended_keymaps = false,
  --       override_keymaps = false,
  --     }
  --   end,
  -- },
  -- {
  --   "karb94/neoscroll.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require('neoscroll').setup({
  --       easing = 'sine',
  --     })
  --   end
  -- },
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
  },
  {
    "uga-rosa/ccc.nvim",
    config = true,
    cmd = "CccPick",
  },
  {
    "edluffy/hologram.nvim",
    ft = { "md", "txt" },
    config = function()
      require("hologram").setup {
        auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
      }
    end,
  },
  {
    "kazhala/close-buffers.nvim",
    event = "VeryLazy",
  },
  -- TODO: large file to slow...
  -- {
  --   "gelguy/wilder.nvim",
  --   lazy = false,
  --   config = function()
  --     local wilder = require "wilder"
  --     wilder.setup { modes = { "/", "?" }, enable_cmdline_enter = true }
  --     wilder.set_option(
  --       "renderer",
  --       wilder.popupmenu_renderer(wilder.popupmenu_border_theme {
  --         highlights = {
  --           border = "Normal", -- highlight to use for the border
  --         },
  --         -- 'single', 'double', 'rounded' or 'solid'
  --         -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
  --         border = "rounded",
  --       })
  --     )
  --   end,
  -- },
  -- TODO: notify is render slow
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     throttle = 3000 / 30,
  --     commands = {
  --       history = {
  --         view = "vsplit",
  --       },
  --     },
  --     messages = {
  --       enabled = true,              -- enables the Noice messages UI
  --       view = "mini",               -- default view for messages
  --       view_error = "notify",       -- view for errors
  --       view_warn = "notify",        -- view for warnings
  --       view_history = "messages",   -- view for :messages
  --       view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  --     },
  --     lsp = {
  --       -- hover = {
  --       --   enabled = true,
  --       -- },
  --       -- signature = {
  --       --   enabled = true,
  --       -- },
  --       -- progress = {
  --       --   enabled = false,
  --       -- },
  --       -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --       override = {
  --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --         ["vim.lsp.util.stylize_markdown"] = true,
  --         ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
  --       },
  --     },
  --     presets = {
  --       bottom_search = true,
  --       lsp_doc_border = true,
  --     },
  --     views = {
  --       notify = {
  --         level = 'error',
  --         merge = true,
  --         replace = true,
  --       },
  --       cmdline = 'bottom',
  --       -- cmdline_popup = {
  --       --   position = {
  --       --     row = 20,
  --       --     col = "50%",
  --       --   },
  --       --   size = {
  --       --     width = 60,
  --       --     height = "auto",
  --       --   },
  --       --   filter_options = {},
  --       -- },
  --       -- popupmenu = {
  --       --   relative = "editor",
  --       --   position = {
  --       --     row = 22,
  --       --     col = "50%",
  --       --   },
  --       --   size = {
  --       --     width = 60,
  --       --     height = 10,
  --       --   },
  --       --   border = {
  --       --     style = "rounded",
  --       --     padding = { 0, 1 },
  --       --   },
  --       --   win_options = {
  --       --     winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },""
  --       --   },
  --       -- },
  --     },
  --   },
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --     "hrsh7th/nvim-cmp",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  -- },
  {
    "AckslD/messages.nvim",
    event = "VeryLazy",
    config = function()
      require("messages").setup()
      PrintDebug = function(val)
        require("messages.api").capture_thing(val)
      end
    end,
  },
  {
    "chrisgrieser/nvim-genghis",
    event = "CmdlineEnter",
    dependencies = {
      "stevearc/dressing.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-omni",
    },
  },
  {
    "vidocqh/data-viewer.nvim",
    ft = { "csv", "tsv", "sqlite" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua", -- Optional, sqlite support
    },
    config = function()
      require("data-viewer").setup {
        autoDisplayWhenOpenFile = false,
        maxLineEachTable = 100,
        columnColorEnable = true,
        columnColorRoulette = { -- Highlight groups
          "DataViewerColumn0",
          "DataViewerColumn1",
          "DataViewerColumn2",
        },
        view = {
          float = false, -- False will open in current window
          width = 0.8,   -- Less than 1 means ratio to screen width, valid when float = true
          height = 0.8,  -- Less than 1 means ratio to screen height, valid when float = true
          zindex = 50,   -- Valid when float = true
        },
        keymap = {
          quit = "q",
          next_table = "<C-l>",
          prev_table = "<C-h>",
        },
      }
      vim.cmd [[highlight DataViewerColumn0 guifg=#e6cc00]]
      vim.cmd [[highlight DataViewerColumn1 guifg=#cc3333]]
      vim.cmd [[highlight DataViewerColumn2 guifg=#00cc00]]
    end,
  },
  {
    "utilyre/sentiment.nvim",
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "smjonas/live-command.nvim",
    event = "VeryLazy",
    config = function()
      require("live-command").setup {
        commands = {
          Norm = { cmd = "norm" },
        },
      }
    end,
  },
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    config = function()
      require("yanky").setup {
        ring = {
          history_length = 3000,
          storage = "shada" -- 状況次第ではsqliteに変えてもよさそう,
        },
      }
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")

      vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
    end,
  },
  {
    "Wansmer/treesj",
    cmd = "TSJToggle",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup { --[[ your config ]]
      }
    end,
  },
  {
    "chrisgrieser/nvim-alt-substitute",
    opts = true,
    -- lazy-loading with `cmd =` does not work well with incremental preview
    event = "CmdlineEnter",
  },
  {
    "cshuaimin/ssr.nvim",
    event = "VeryLazy",
    config = function()
      require("ssr").setup {
        border = "rounded",
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        adjust_window = true,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      }
      vim.keymap.set({ "n", "x" }, "<leader>sr", function()
        require("ssr").open()
      end)
    end,
  },
  {
    "nmac427/guess-indent.nvim",
    event = "VeryLazy",
    config = function()
      require("guess-indent").setup {}
    end,
  },
  {
    "jedrzejboczar/toggletasks.nvim",
    config = function()
      require("toggletasks").setup {
        scan = {
          global_cwd = true,   -- vim.fn.getcwd(-1, -1)
          tab_cwd = true,      -- vim.fn.getcwd(-1, tab)
          win_cwd = true,      -- vim.fn.getcwd(win)
          lsp_root = true,     -- root_dir for first LSP available for the buffer
          dirs = {},           -- explicit list of directories to search or function(win): dirs
          rtp = true,          -- scan directories in &runtimepath
          rtp_ftplugin = true, -- scan in &rtp by filetype, e.g. ftplugin/c/toggletasks.json
        },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup {
        snippet_engine = "luasnip",
        languages = {
          ruby = {
            template = {
              annotation_convention = "yard",
            },
          },
        },
      }
    end,
  },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",                         -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      condition = function(buf)
        local fn = vim.fn
        -- harpoon menuなど特殊なbufferは除外する
        if fn.getbufvar(buf, "&buftype") ~= '' then
          return false
        end
        return true
      end
    },
  },
  {
    "ecthelionvi/NeoComposer.nvim",
    event = "VeryLazy",
    dependencies = { "kkharji/sqlite.lua" },
    config = function()
      require("NeoComposer").setup()
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- Recommended - see "Configuring" below for more config options
        transparent = true,
        italic_comments = false,
        hide_fillchars = false,
        borderless_telescope = false,
        terminal_colors = false,
      })
      vim.cmd("colorscheme cyberdream") -- set the colorscheme
    end,
  },
  {
    "nvim-focus/focus.nvim",
    event = "VeryLazy",
    config = function()
      require("focus").setup({
        autoresize = {
          enable = true,
          minwidth = 10,  -- Force minimum width for the unfocused window
          minheight = 10, -- Force minimum height for the unfocused window
          height_quickfix = 5
        },
      })
    end,
  },
  {
    'lewis6991/whatthejump.nvim',
    event = "VeryLazy",
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    config = function()
      require('tiny-inline-diagnostic').setup()
    end
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup()
    end,
  },
  {
    "weizheheng/ror.nvim",
    event = "VeryLazy",
  },
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
  },
  {
    "oysandvik94/curl.nvim",
    cmd = { "CurlOpen", "CurlCollection" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>S",
        function() require("rip-substitute").sub() end,
        mode = { "n", "x" },
        desc = " rip substitute",
      },
    },
  },
  {
    "amrbashir/nvim-docs-view",
    lazy = true,
    cmd = "DocsViewToggle",
    opts = {
      position = "bottom",
      width = 60
    }
  },
  {
    'xvzc/chezmoi.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
        callback = function()
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end,
      })
      require("chezmoi").setup {
        -- your configurations
      }
    end
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
      require("notify").setup {
        -- your configurations
      }
    end
  },
  {
    'b0o/incline.nvim',
    event = 'VeryLazy',
    config = function()
      local helpers = require 'incline.helpers'
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { filename, gui = modified and 'bold,italic' or 'bold' },
            ' ',
            guibg = '#44406e',
          }
        end,
      }
    end,
    dependencies = {
      { "SmiteshP/nvim-navic" },
      { "nvim-tree/nvim-web-devicons" },
    },
  },
  {
    'stevearc/quicker.nvim',
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
}

return plugins
