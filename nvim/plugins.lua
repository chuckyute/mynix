require("Comment").setup({})

require("lazy").setup({
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		config = function()
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { desc = desc })
			end

			map("<leader>sh", builtin.help_tags, "[S]earch [H]elp")
			map("<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
			map("<leader>sf", builtin.find_files, "[S]earch [F]iles")
			map("<leader>ss", builtin.builtin, "[S]earch [S]elect Telescope")
			map("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
			map("<leader>sg", builtin.live_grep, "[S]earch by [G]rep")
			map("<leader>sd", builtin.diagnostics, "[S]earch [D]iagnostics")
			map("<leader>sr", builtin.resume, "[S]earch [R]esume")
			map("<leader>s.", builtin.oldfiles, '[S]earch Recent Files "repeat"')
			map("<leader><leader>", builtin.buffers, "[ ] existing buffers")

			-- Slightly advanced example of overriding default behavior and theme
			map("<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, "[/] Fuzzily search in current buffer")

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			map("<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, "[S]earch [/] in Open Files")

			-- Shortcut for searching your Neovim configuration files
			map("<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, "[S]earch [N]eovim files")
		end,
	},
	install = { missing = false },
})
