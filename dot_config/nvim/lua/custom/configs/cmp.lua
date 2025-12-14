-- cSpell:disable
local cmp = require "cmp"

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local options = {
  mapping = {
    -- ["<Tab>"] = vim.schedule_wrap(function(fallback)
    --   if cmp.visible() and has_words_before() then
    --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --   else
    --     fallback()
    --   end
    -- end),
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "copilot",  priority = 5 },
    { name = "nvim_lsp_signature_help", priority = 5 },
    { name = "css-variables", priority = 3, keyword_length = 2, ft = { 'css', 'vue', 'scss', 'sass'} },
    { name = "nvim_lsp", priority = 2, keyword_length = 2 },
    { name = "luasnip",  priority = 1, keyword_length = 2 },
    { name = "nvim_lua", priority = 1, keyword_length = 2, ft = "lua" },
    { name = "async_path", priority = 1, keyword_length = 5 },
    {
      name = "buffer",
      priority = 2,
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
  },
  sorting = {
    priority_weight = 3,
    comparators = {
      -- https://github.com/hrsh7th/nvim-cmp/pull/1537/files
      require("copilot_cmp.comparators").prioritize,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.exact,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
}

return options
