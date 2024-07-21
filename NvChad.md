## configureation

luaがhash構造になっているので、hashでmergeするのがベースとなる.

https://nvchad.com/docs/config/walkthrough

`vim.tbl_deep_extend`を使用してmergeする

```lua
-- table 1
local person = {
    name = "joe",
    age = 19,
}

-- table 2
local someone = {
    name = "siduck",
}

-- "force" will overwrite equal values from the someone table over the person table
local result = vim.tbl_deep_extend("force", person, someone)

-- result :
{
    name = "siduck", -- as you can see, name has been overwritten
    age = 19,
}
```

### ui

uiに関しては、独自の用意されている部分がある
statuslineやtabbuflineなどがある

https://nvchad.com/docs/config/nvchad_ui
