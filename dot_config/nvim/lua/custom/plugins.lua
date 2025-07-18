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
      },
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
    enabled = false,
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
    "iguanacucumber/magazine.nvim",
    enabled = true,
    name = "nvim-cmp",
    dependencies = {
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
      { "iguanacucumber/mag-buffer",   name = "cmp-buffer" },
      { "iguanacucumber/mag-cmdline",  name = "cmp-cmdline" },
    },
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
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        }),
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

      -- local snippet_path = vim.fn.expand("~/.snippets/")
      -- local filetypes = {
      --   javascript = "javascript.lua",
      --   ruby = "ruby.lua",
      -- }
      --
      -- for ft, file in pairs(filetypes) do
      --   local snippets = loadfile(snippet_path .. file)()
      --   require("luasnip").add_snippets(ft, snippets)
      -- end

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
        finder = {
          right_width = 0.7,
          default = 'tyd+def+imp+ref',
          keys = {
            vsplit = 'v',
            split = 's',
            tabe = 't',
            tabnew = 'r'
          }
        },
        definition = {
          keys = {
            edit = 'o',
            vsplit = 'v',
            split = 's',
            tabe = 't'
          }
        },
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
    enabled = false,
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
    "smoka7/hop.nvim",
    version = "*",
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
      { "smoka7/hop.nvim" }, -- for curl, log wrapper
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
          -- auto_trigger = true,
          -- debounce = 75,
          -- keymap = {
          --   accept = "<C-]>",
          --   accept_word = false,
          --   accept_line = false,
          --   next = "<C-n>",
          --   prev = "<C-p>",
          --   dismiss = "<C-e>",
          -- },
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
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter", "LspAttach" },
    fix_pairs = true,
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
        large_file_cutoff = 1000,
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
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    dependencies = {
      "kkharji/sqlite.lua",
      { "nvim-telescope/telescope.nvim" },
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
        default_command = "/usr/local/bin/im-select",
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
        max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
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
        use_git_branch = true,
        suppressed_dirs = { '~/', '~/Downloads', '/' },
        auto_restore_last_session = false,
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
      require('bookmarks').setup {
        save_file = vim.fn.expand(bookmark_dir .. "/" .. current_branch),
        keywords = {
          ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
          ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
          ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
          ["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
        },
      }
    end
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
              -- "--port",
              -- "${port}",
              "--command",
              "--",
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
          command = "bin/rails",
          script = "server -p 3000",
        },
      }
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
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
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
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end
      require("ufo").setup {
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = { default = { 'imports', 'comment' } },
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
    opts = {
      queue_most_recent = true,
      keymaps = {
        play_macro = "<m-q>",
        yank_macro = "<m-y>",
        stop_macro = "<m-s>",
        toggle_record = "<m-t>",
        cycle_next = "<c-n>",
        cycle_prev = "<c-p>",
        toggle_macro_menu = "<m-q>",
      },
    }
  },
  {
    "nvim-focus/focus.nvim",
    event = "VeryLazy",
    config = function()
      local ignore_filetypes = { "qf", "neo-tree", "neo-tree-popup", "notify", "help", "dashboard", "NvimTree" }
      local ignore_buftypes = { 'nofile', 'prompt', 'popup', 'terminal', 'quickfix', 'help' }

      local augroup =
          vim.api.nvim_create_augroup('FocusDisable', { clear = true })

      vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
          then
            vim.w.focus_disable = true
          else
            vim.w.focus_disable = false
          end
        end,
        desc = 'Disable focus autoresize for BufType',
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = 'Disable focus autoresize for FileType',
      })

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
    "weizheheng/ror.nvim",
    event = "VeryLazy",
  },
  {
    "oysandvik94/curl.nvim",
    cmd = { "CurlOpen", "CurlCollection", "CurlClose" },
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
        timeout = 2500,
        max_width = 80,
        stages = "static",
      }
    end
  },
  {
    'stevearc/quicker.nvim',
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  -- partial jumpの関係で必要
  {
    "tpope/vim-rails",
    lazy = false,
  },
  {
    "monaqa/dial.nvim",
    event = "VeryLazy",
  },
  {
    'f-person/git-blame.nvim',
    event = "VeryLazy",
    config = function()
      -- vim.g.gitblame_display_virtual_text = 0
      vim.g.gitblame_schedule_event = 'CursorHold'
      vim.g.gitblame_clear_event = 'CursorHoldI'
      require('gitblame').setup {
        enabled = true,
        message_template = " <date> | <summary> | <author>",
        date_format = "%Y/%m/%d(%r)",
      }
    end
  },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      -- options
    },
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "j-hui/fidget.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" }
      },
      {
        "HakonHarnes/img-clip.nvim",
        ft = { 'markdown', 'codecompanion' },
        opts = {
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = "[Image]($FILE_PATH)",
              use_absolute_path = true,
            },
          },
        },
      },
      {
        "Davidyz/VectorCode",
        version = "*",      -- optional, depending on whether you're on nightly or release
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "VectorCode", -- if you're lazy-loading VectorCode
      },
      {
        "ravitemer/codecompanion-history.nvim"
      }
    },
    config = function()
      require("codecompanion.fidget-spinner"):init()
      require("codecompanion.fidget-progress-message"):init()
      local copilot_token_path = vim.fn.expand("~/.config/github-copilot/hosts.json")
      local copilot_available = vim.fn.filereadable(copilot_token_path) == 1
      local adapter = {
        name = 'copilot',
        model = 'claude-sonnet-4-20250514' -- 'gpt-4.1'
      }
      if copilot_available == true then
      elseif vim.fn.executable("op") == 1 then
        adapter = {
          name = 'openai',
          model = 'gpt-4.1-nano'
        }
        vim.notify("Use OpenAI adapter", vim.log.levels.WARN)
      else
        vim.notify("No available CodeCompanion adapter (OpenAI or Copilot)", vim.log.levels.ERROR)
        return
      end
      require("codecompanion").setup({
        language = "Japanese",
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = 'claude-sonnet-4-20250514'
                }
              }
            })
          end,
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = "cmd:op read op://personal/OpenAI/apikey",
              },
              schema = {
                model = {
                  default = 'gpt-4.1-nano'
                }
              }
            })
          end,
        },
        display = {
          diff = {
            enabled = true,
            close_chat_at = 240,  -- Close an open chat buffer if the total columns of your display are less than...
            layout = "vertical",  -- vertical|horizontal split for default provider
            opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
            provider = "default", -- default|mini_diff
          },
          chat = {
            auto_scroll = false,
            show_header_separator = true,
            window = {
              layout = "buffer", -- float|vertical|horizontal|buffer
            },
          }
        },
        strategies = {
          chat = {
            adapter = adapter,
            opts = {
              ---Decorate the user message before it's sent to the LLM
              ---@param message string
              ---@param adapter CodeCompanion.Adapter
              ---@param context table
              ---@return string
              prompt_decorator = function(message, adapter, context)
                return string.format([[<prompt>%s</prompt>]], message)
              end,
              completion_provider = "cmp",
            },
          },
          inline = {
            adapter = adapter,
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_vars = true,
              make_slash_commands = true,
              show_result_in_chat = true
            }
          },
          history = {
            enabled = true,
            opts = {
              -- Keymap to open history from chat buffer (default: gh)
              keymap = "gh",
              -- Keymap to save the current chat manually (when auto_save is disabled)
              save_chat_keymap = "sc",
              -- Save all chats by default (disable to save only manually using 'sc')
              auto_save = true,
              -- Number of days after which chats are automatically deleted (0 to disable)
              expiration_days = 0,
              -- Customize picker keymaps (optional)
              picker_keymaps = {
                rename = { n = "r", i = "<M-r>" },
                delete = { n = "d", i = "<M-d>" },
                duplicate = { n = "<C-y>", i = "<C-y>" },
              },
              ---Automatically generate titles for new chats
              auto_generate_title = false,
              ---On exiting and entering neovim, loads the last chat on opening chat
              continue_last_chat = true,
              ---When chat is cleared with `gx` delete the chat from history
              delete_on_clearing_chat = false,
              ---Directory path to save the chats
              dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
              ---Enable detailed logging for history extension
              enable_logging = false,

              -- Summary system
              summary = {
                -- Keymap to generate summary for current chat (default: "gcs")
                create_summary_keymap = "gcs",
                -- Keymap to browse summaries (default: "gbs")
                browse_summaries_keymap = "gbs",
              },
            }
          },
          -- required vectorcode cli
          vectorcode = {
            ---@type VectorCode.CodeCompanion.ExtensionOpts
            opts = {
              tool_group = {
                -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
                enabled = true,
                -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
                -- if you use @vectorcode_vectorise, it'll be very handy to include
                -- `file_search` here.
                extras = {},
                collapse = true, -- whether the individual tools should be shown in the chat
              },
            },
          },
        },
        sources = {
          per_filetype = {
            codecompanion = { "codecompanion" },
          }
        },
        prompt_library = {
          GeneratePRDescription = {
            strategy = "chat",
            description = "Github Pull Requestの説明文を作成する",
            opts = { short_name = "generate_pr_desc", is_slash_cmd = true },
            references = {
              {
                type = "file",
                path = { ".github/PULL_REQUEST_TEMPLATE.md" },
              },
            },
            prompts = {
              {
                role = "user",
                content = function()
                  local pr = vim.fn.input("PR番号を入力してください: ")
                  if pr == "" then
                    vim.notify("PR番号が未入力です", vim.log.levels.ERROR)
                    return nil
                  end

                  local commits = vim.fn.systemlist("gh pr view " .. pr .. " --json commits --jq '.commits[].oid'")
                  if #commits == 0 then
                    vim.notify("コミットが取得できませんでした", vim.log.levels.ERROR)
                    return nil
                  end

                  local first = commits[1]
                  local last = commits[#commits]
                  local diff = vim.fn.systemlist("git diff " .. first .. "^.." .. last)

                  return string.format([[
                  以下の git diff に基づいて GitHub Pull Request の説明をすべて日本語で作成してください。
                  目的、主な変更点、関連するコンテキストを含めてください。
                  エンジニアがレビューしやすく、資産として残るような完璧な説明となるようにしてください。

                  また、GitHub Pull Request の説明は、PULL_REQUEST_TEMPLATE.md をテンプレートとして活用してください。
                  コミット内容の説明については、次に続くコミット情報を元に判断してください。

                  # diff:
                  %s

                  # commits:
                  %s
                ]], table.concat(diff, "\n"), table.concat(commits, "\n"))
                end,
              },
            },
          },
          GeneratePRReview = {
            strategy = "chat",
            description = "Github Pull RequestのPR Reviewをする",
            opts = { short_name = "generate_pr_review", is_slash_cmd = true },
            prompts = {
              {
                role = "system",
                content = [[
                  あなたは10年以上の経験を持つ上級Ruby on Railsエンジニアです。
                  以下のコードに対して、プロフェッショナルなコードレビューを行ってください。

                  ## レビューの観点（必ずすべて網羅してください）

                  1. **コードの意図が明確か**
                     - 命名の適切さ（モデル名、変数名、メソッド名）
                     - コメントの有無と内容の妥当性

                  2. **Railsのベストプラクティスに沿っているか**
                     - Fat Model / Skinny Controller
                     - ActiveRecordの使い方（N+1やスコープ）
                     - Strong Parametersやバリデーションの活用

                  3. **パフォーマンス面の懸念**
                     - 不要なクエリ、N+1の発生有無
                     - 無駄な処理やロジックの繰り返し

                  4. **保守性と再利用性**
                     - 冗長なコードの削減提案
                     - ヘルパーやConcernに切り出すべきロジックの指摘

                  5. **セキュリティ上の懸念点**
                     - SQLインジェクションやCSRF、XSSの可能性
                     - ユーザー入力の扱いの妥当性

                  6. **テストしやすいコードか**
                     - テスト容易性と関心の分離
                     - 不要な依存の排除提案

                  7. **書き換え案があれば具体的なコードで提示**
                     - diff形式またはbefore/after形式で示す

                  8. **影響範囲が広すぎないか**
                     - 改修が影響する範囲を確認する(例: methodをgrepするなど)
                     - 影響する範囲が広すぎる場合は、PRを分けるや、実装を調整するなどを具体的に提案する

                  ## レビューの出力形式

                  - 観点ごとに項目を分け、簡潔かつ網羅的に記載
                  - 否定的な指摘も、建設的かつ改善案付きで示す
                  - もし問題がなければ「特に問題なし」と明記
                  - 問題のある部分は、強調する
                ]]
              },
              {
                role = "user",
                content = function()
                  local pr = vim.fn.input("PR番号を入力してください: ")
                  if pr == "" then
                    vim.notify("PR番号が未入力です", vim.log.levels.ERROR)
                    return nil
                  end

                  local commits = vim.fn.systemlist("gh pr view " .. pr .. " --json commits --jq '.commits[].oid'")
                  if #commits == 0 then
                    vim.notify("コミットが取得できませんでした", vim.log.levels.ERROR)
                    return nil
                  end

                  local first = commits[1]
                  local last = commits[#commits]
                  local files = vim.fn.systemlist("git diff --name-only " .. first .. ".." .. last)
                  local diff = vim.fn.systemlist("git diff " .. first .. ".." .. last)

                  return string.format([[
                    以下がレビュー対象のコードです:
                    # files:
                    %s

                    # commits:
                    %s

                    # diff:
                    %s
                  ]], table.concat(files, "\n"), table.concat(commits, "\n"), table.concat(diff, "\n"))
                end,
              },
            },
          },
          Explain = {
            strategy = "chat",
            description = "コードを日本語で説明する",
            opts = { short_name = "explain", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "このコードを日本語で説明してください。",
              },
            },
          },
          GenerateExample = {
            strategy = "chat",
            description = "使い方の具体例を生成する",
            opts = { short_name = "example", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "このコードの使い方を示す具体的な例を日本語で生成してください。",
              },
            },
          },
          Review = {
            strategy = "chat",
            description = "コードレビューを依頼する",
            opts = { short_name = "review", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "このコードを日本語でレビューしてください。",
              },
            },
          },
          Fix = {
            strategy = "chat",
            description = "コードのバグ修正を依頼する",
            opts = { short_name = "fix", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
              },
            },
          },
          SolveError = {
            strategy = "chat",
            description = "エラー解決のアドバイスをもらう",
            opts = { short_name = "error", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "選択したエラーメッセージに対する解決方法を日本語で教えてください。",
              },
            },
          },
          Optimize = {
            strategy = "chat",
            description = "パフォーマンスと可読性の最適化",
            opts = { short_name = "optimize", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "選択したコードを最適化し、パフォーマンスと可読性（特にネーミング）を向上させてください。説明は日本語でお願いします。",
              },
            },
          },
          Docs = {
            strategy = "chat",
            description = "ドキュメントコメントを生成する",
            opts = { short_name = "docs", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "選択したコードに関するドキュメントコメントを日本語で生成してください。",
              },
            },
          },
          DocsAnnotation = {
            strategy = "inline",
            description = "methodのAnnotationを生成する",
            opts = { short_name = "docs_annotation", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "選択したコードに関するAnnotationを、コードリーディングがしやすくなるように生成してください。",
              },
            },
          },
          GenerateCode = {
            strategy = "inline",
            description = "機能実装コードを生成する",
            opts = { short_name = "gen_code", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "特定の機能を実装するコードを生成してください。説明は日本語でお願いします。",
              },
            },
          },
          Translate = {
            strategy = "inline",
            description = "コードを他言語に変換する",
            opts = { short_name = "translate", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "選択したコードを別のプログラミング言語に変換してください。説明は日本語でお願いします。",
              },
            },
          },
          SuggestRefactor = {
            strategy = "chat",
            description = "改善提案をお願いする",
            opts = { short_name = "suggest", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "選択したコードの改善提案をください。説明は日本語でお願いします。",
              },
            },
          },
          Debug = {
            strategy = "chat",
            description = "バグの原因を探る",
            opts = { short_name = "debug", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "選択したコードのバグを見つけてください。説明は日本語でお願いします。",
              },
            },
          },
          Tests = {
            strategy = "chat",
            description = "ユニットテストを生成する",
            opts = { short_name = "tests", is_slash_cmd = true },
            prompts = {
              {
                role = "user",
                content = "選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
              },
            },
          },
          Commit = {
            strategy = "chat",
            description = "コミットメッセージを生成する",
            opts = { short_name = "commit", is_slash_cmd = true },
            references = {
              {
                type = "url",
                url = "https://www.conventionalcommits.org/en/v1.0.0/",
              },
            },
            prompts = {
              {
                role = "user",
                content = [[
以下の条件に基づいて、英語でコミットメッセージを生成してください:
1. Conventional Commits の形式を使用する。
2. 差分内容に基づき、適切なプレフィックス (e.g., feat, fix, chore, docs, refactor, test) を付与する。
3. タイトルは簡潔的に、先頭を動詞かつ大文字で簡潔に記載する。
4. 本文は変更の目的や背景を文章で記載して、変更の概要を箇条書きで説明する。
        ]],
              },
            },
          },
          CommitStaged = {
            strategy = "chat",
            description = "ステージ済み差分からコミットメッセージを生成する",
            opts = { short_name = "commitstaged", is_slash_cmd = true },
            -- references = {
            --   {
            --     type = "url",
            --     url = "https://www.conventionalcommits.org/en/v1.0.0/",
            --   },
            -- },
            prompts = {
              {
                role = "system",
                content = [[
                以下の条件に基づいて、英語でコミットメッセージを生成してください:
                1. Conventional Commits の形式を使用する。
                2. 差分内容に基づき、適切なプレフィックス (e.g., feat, fix, chore, docs, refactor, test) を付与する。
                3. タイトルは簡潔的に、先頭を動詞かつ大文字で簡潔に記載する。
                4. 本文は変更の目的や背景を文章で記載して、変更の概要を箇条書きで説明する。
                ]]
              },
              {
                role = "user",
                content = function()
                  local diff = vim.fn.systemlist("git diff --cached")
                  return string.format([[
以下のdiffの内容を元に適切なコミットメッセージを作成してください。

```git
%s
```
          ]], table.concat(diff, "\n"))
                end,
              },
            },
          },
        },
      })
      vim.cmd([[cab cc CodeCompanion]])
    end
  },
  {
    "AckslD/nvim-neoclip.lua",
    envet = "VeryLazy",
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
      { 'kkharji/sqlite.lua',           module = 'sqlite' },
    },
    config = function()
      require('neoclip').setup({
        history = 10000,
        enable_persistent_history = true,
        length_limit = 10000,
        continuous_sync = true,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
        filter = nil,
        preview = true,
        prompt = nil,
        default_register = '"',
        default_register_macros = 'q',
        enable_macro_history = true,
        content_spec_column = false,
        disable_keycodes_parsing = false,
        dedent_picker_display = true,
        initial_mode = 'normal',
        on_select = {
          move_to_front = false,
          close_telescope = false,
        },
        on_paste = {
          set_reg = false,
          move_to_front = false,
          close_telescope = true,
        },
        on_replay = {
          set_reg = false,
          move_to_front = false,
          close_telescope = true,
        },
        on_custom_action = {
          close_telescope = true,
        },
        keys = {
          telescope = {
            i = {
              select = '<c-p>',
              paste = '<c-k>',
              paste_behind = '<cr>',
              replay = '<c-q>', -- replay a macro
              delete = '<c-d>', -- delete an entry
              edit = '<c-e>',   -- edit an entry
              custom = {},
            },
            n = {
              select = 'p',
              paste = 'P',
              paste_behind = '<cr>',
              replay = 'q',
              delete = 'd',
              edit = 'e',
              custom = {},
            },
          },
        },
      })
    end,
  },
  {
    "uga-rosa/translate.nvim",
    event = "VeryLazy",
    config = function()
      require("translate").setup({
        default = {
          command = "translate_shell",
        },
        preset = {
          output = {
            split = {
              append = true,
            },
          },
        },
      })
    end
  },
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      -- check the installation instructions at
      -- https://github.com/folke/snacks.nvim
      "folke/snacks.nvim"
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        function() require 'treesitter_indent_object.textobj'.select_indent_outer() end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer)",
      },
      {
        "aI",
        function() require 'treesitter_indent_object.textobj'.select_indent_outer(true) end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer, line-wise)",
      },
      {
        "ii",
        function() require 'treesitter_indent_object.textobj'.select_indent_inner() end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, partial range)",
      },
      {
        "iI",
        function() require 'treesitter_indent_object.textobj'.select_indent_inner(true, 'V') end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
      },
    },
  },
  {
    "wsdjeg/quickfix.nvim",
    ft = { "qf" },
  },
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    dependencies = {
      { "ibhagwan/fzf-lua" },              --optional: if you want to use fzf-lua to pick scratch file. Recommanded, since it will order the files by modification datetime desc. (require rg)
      { "nvim-telescope/telescope.nvim" }, -- optional: if you want to pick scratch file by telescope
      { "stevearc/dressing.nvim" }         -- optional: to have the same UI shown in the GIF
    },
    config = function()
      require("scratch").setup({
        -- scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim",
        scratch_file_dir = "~/Documents/andpad/50-Resource/Scratch",
      })
    end
  },
  {
    "folke/trouble.nvim",
    opts = {
      throttle = {
        refresh = 250,                           -- fetches new data when needed
        update = 100,                            -- updates the window
        render = 100,                            -- renders the window
        follow = 250,                            -- follows the current item
        preview = { ms = 100, debounce = true }, -- shows the preview for the current item
      }
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}

return plugins
