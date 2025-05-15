-- Configure conform.nvim for formatting
local conform = require("conform")

conform.setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style
		local disable_filetypes = { c = true, cpp = true }
		return {
			timeout_ms = 500,
			lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixfmt" },
	},
})

-- Set up format keybinding
vim.keymap.set("", "<leader>f", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "[F]ormat buffer" })

-- Format command, similar to the one in lsp.lua
vim.api.nvim_create_user_command("Format", function(_)
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format current buffer with conform.nvim" })
