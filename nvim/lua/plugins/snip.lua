return {
  {
    "L3MON4D3/LuaSnip",
    version = "2", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_snipmate").load("~/.config/nvim/snippets/")
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      local function box(opts)
        -- NOTE: this had to be a function, otherwise `textwidth` was 0 during
        -- initialization. Still need to better understand when variables are
        -- populated.
        local function box_width()
          return opts.box_width or vim.opt.textwidth:get()
        end
        --
        local function padding(cs, input_text)
          local spaces = box_width() - (2 * #cs)
          spaces = spaces - #input_text
          return spaces / 2
        end
        --
        -- https://github.com/L3MON4D3/LuaSnip/issues/151#issuecomment-912641351
        local comment_string = function()
          return require("luasnip.util.util").buffer_comment_chars()[1]
        end
        --
        return {
          f(function()
            local cs = comment_string()
            return string.rep(string.sub(cs, 1, 1), box_width())
          end, { 1 }),
          t({ "", "" }),
          f(function(args)
            local cs = comment_string()
            return cs .. string.rep(" ", math.floor(padding(cs, args[1][1])))
          end, { 1 }),
          i(1, "placeholder"),
          f(function(args)
            local cs = comment_string()
            return string.rep(" ", math.ceil(padding(cs, args[1][1]))) .. cs
          end, { 1 }),
          t({ "", "" }),
          f(function()
            local cs = comment_string()
            return string.rep(string.sub(cs, 1, 1), box_width())
          end, { 1 }),
        }
      end

      local function MyLine(opts)
        -- NOTE: this had to be a function, otherwise `textwidth` was 0 during
        -- initialization. Still need to better understand when variables are
        -- populated.
        local function line_width()
          return opts.line_width or vim.opt.textwidth:get()
        end
        local function padding(cs, input_text)
          local spaces = line_width() - (2 * #cs)
          spaces = spaces - #input_text
          return spaces / 2
        end
        local comment_string = function()
          return require("luasnip.util.util").buffer_comment_chars()[1]
        end
        return {
          f(function(args)
            local cs = comment_string()
            return string.rep(string.sub(cs, 1, 1), math.floor(padding(cs, args[1][1]))) .. " "
          end, { 1 }),
          i(1, "placeholder"),
          f(function(args)
            local cs = comment_string()
            return " " .. string.rep(string.sub(cs, 1, 1), math.ceil(padding(cs, args[1][1])))
          end, { 1 }),
        }
      end

      ls.add_snippets("all", {
        -- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#box-comment-like-ultisnips
        s({ trig = "box" }, box({ box_width = 48 })),
        s({ trig = "bbox" }, box({})),
        s({ trig = "line" }, MyLine({ line_width = 48 })),
        s({ trig = "lline" }, MyLine({})),
      })
      -- ls.add_snippets("r", s({ trig = "p", "%>%" }))
    end,
    -- keys = function()
    --   return {}
    -- end,
  },
}
