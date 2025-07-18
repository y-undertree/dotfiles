-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
-- これは反映される
M.override = {
  Comment = {
    italic = true,
    fg='#999999',
  },
  ["@comment"] = { fg = "#7faa7f", italic = true },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

return M
