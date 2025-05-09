require("Comment").setup({})

require("lazy").setup({
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		config = false,
	},
	install = { missing = false },
})
