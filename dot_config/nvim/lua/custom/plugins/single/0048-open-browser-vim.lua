return {
  {
    "tyru/open-browser.vim",
    init = function()
      require("core.utils").lazy_load "open-browser.vim"
    end,
  },
}