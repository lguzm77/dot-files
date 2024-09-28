return {
	"iamcco/markdown-preview.nvim",
  -- Some other tools to look at: Glow for cmdline md rendering and Quartz for a blog in mardown
  event = "VeryLazy",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
}
