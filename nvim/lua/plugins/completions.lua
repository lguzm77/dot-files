return {
	{
		"L3MON4D3/LuaSnip",
		event = "VeryLazy",
		version = "v2.3",
		config = function()
			local ls = require("luasnip")
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
					t("app.listen(3000, async () => console.log(`listening on port 3000`));"),
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
	-- TODO: move this to lsp.lua
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- load plugin just before entering insert mode
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer", -- source for text in buffer
			"hrsh7th/cmp-path", -- ssource for file system paths
			"hrsh7th/cmp-cmdline", -- source for command line completions
			"saadparwaiz1/cmp_luasnip", -- lua snippets
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim", -- pictograms
		},

		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			require("luasnip.loaders.from_vscode").lazy_load()

			local completion_sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" }, -- text within the current buffer
				{ name = "path" }, -- file system paths
			}

			vim.opt.completeopt = "menu,menuone,noselect"
			cmp.setup({
				completion = { completeopt = "menu,menuone,preview,noselect" },
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n"] = cmp.mapping.select_next_item(),
					["<C-p"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources(completion_sources),

				-- icons
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						ellipsis_char = "...",
					}),
				},
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
