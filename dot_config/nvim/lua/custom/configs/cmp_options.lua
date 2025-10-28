-- cSpell:disable
local cmp = require "cmp"

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local options = {
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
  },
  sources = {
    { name = "copilot",  priority = 1 },
    { name = "nvim_lsp_signature_help", priority = 1 },
    { name = "css-variables", priority = 1, keyword_length = 1, ft = 'css' },
    { name = "nvim_lsp", priority = 1, keyword_length = 2 },
    { name = "luasnip",  priority = 1, keyword_length = 2 },
    { name = "nvim_lua", priority = 1, keyword_length = 2, ft = "lua" },
    {
      name = "path",
      group_index = 2,
      priority = 5,
    },
    {
      name = "buffer",
      priority = 1,
      option = {
        keyword_length = 3,
        get_bufnrs = function()
          local bufs = {}
          local count = 0
          local limit = 50
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            count = count + 1
            local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
            if count <= limit and byte_size <= 1024 * 256 then
              bufs[buf] = true
            end
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    -- { name = 'treesitter', priority = 2, max_item_count = 5 },
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      -- https://github.com/hrsh7th/nvim-cmp/pull/1537/files
      require("copilot_cmp.comparators").prioritize,
      cmp.config.compare.offset,
      cmp.config.compare.score,
      cmp.config.compare.sort_text,
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
}

return options
