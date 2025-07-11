-- Configure existing plugins
require("lualine").setup({
	icons_enabled = true,
})

require("Comment").setup({})

require("fidget").setup({})

require("luasnip").setup({})

-- Load formatter configuration
pcall(function()
	require("format") -- Load format.lua
end)

-- Gitsigns configuration
if pcall(require, "gitsigns") then
	require("gitsigns").setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	})
end

-- Which-key configuration
if pcall(require, "which-key") then
	require("which-key").setup()

	require("which-key").add({
		{ "<leader>c", group = "[C]ode" },
		{ "<leader>c_", hidden = true },
		{ "<leader>d", group = "[D]ocument" },
		{ "<leader>d_", hidden = true },
		{ "<leader>h", group = "Git [H]unk" },
		{ "<leader>h_", hidden = true },
		{ "<leader>r", group = "[R]ename" },
		{ "<leader>r_", hidden = true },
		{ "<leader>s", group = "[S]earch" },
		{ "<leader>s_", hidden = true },
		{ "<leader>t", group = "[T]oggle" },
		{ "<leader>t_", hidden = true },
		{ "<leader>w", group = "[W]orkspace" },
		{ "<leader>w_", hidden = true },
	})
	-- Document existing key chains for visual mode
	require("which-key").add({
		{ "<leader>h", desc = "Git [H]unk", mode = "v" },
	})
end

-- Todo comments
if pcall(require, "todo-comments") then
	require("todo-comments").setup({
		signs = false,
	})
end

-- Mini plugins collection
if pcall(require, "mini.ai") then
	require("mini.ai").setup({ n_lines = 500 })
end

if pcall(require, "mini.surround") then
	require("mini.surround").setup()
end

if pcall(require, "mini.statusline") then
	local statusline = require("mini.statusline")
	statusline.setup({ use_icons = vim.g.have_nerd_font })
	-- Configure the cursor location section
	statusline.section_location = function()
		return "%2l:%-2v"
	end
end

-- Note: vim-godot doesn't need setup, it's activated automatically for Godot files
