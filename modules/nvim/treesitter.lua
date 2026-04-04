-- Treesitter configuration using Neovim native API
-- Parsers are installed by Nix via nvim-treesitter.withPlugins
-- The old require("nvim-treesitter.configs").setup() API has been removed

-- Enable treesitter highlighting for all filetypes that have a parser
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})
