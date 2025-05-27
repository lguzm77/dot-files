return {
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    version = "v2.3",
    config = function()
      local ls = require "luasnip"
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      ls.add_snippets("javascript", {
        s("express-app", {
          t({ "const express = require('express');", "\t" }), -- \t is for linebreak
          t({ "const bodyParser = require('body-parser');", "\t" }),
          t({ "const axios = require('axios');", "\t" }),
          t({ "", "\t" }),
          t({ "const app = express();", "\t" }),

          t({ "app.use(bodyParser.json());", "\t" }),
          t "app.listen(3000, async () => console.log(`listening on port 3000`));",
        }),
      })
      -- TODO: add snippets for get and post paths
      ls.add_snippets("javascript", {
        s("get-express", {
          t({ "app.get('/n', async (req,res) => {});" }),
        }),
      })

      ls.add_snippets("javascript", {
        s("post-express", {
          t({ "app.post('/n', async (req,res) => {});" }),
        }),
      })
    end,
  },
  {
    -- completion
    "Saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    event = "VeryLazy",
    version = "1.*",
    opts = {
      keymap = { preset = "default" },

      appearance = {
        nerd_font_variant = "mono",
      },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
}
