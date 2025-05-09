require("Comment").setup({})

require("fidget").setup({})

-- Configure nvim-cmp for completion
local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-y>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

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

-- Define a function to set up LSP for specific filetypes
-- Define our LSP on_attach function that will be used for all servers
local on_attach = function(client, bufnr)
	-- Common keymaps
	local bufmap = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	-- Standard LSP keymaps
	bufmap("<leader>r", vim.lsp.buf.rename, "Rename")
	bufmap("<leader>a", vim.lsp.buf.code_action, "Code Action")
	bufmap("gd", vim.lsp.buf.definition, "Go to Definition")
	bufmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
	bufmap("gI", vim.lsp.buf.implementation, "Go to Implementation")
	bufmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")
	bufmap("gr", require("telescope.builtin").lsp_references, "Find References")
	bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
	bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
	bufmap("K", vim.lsp.buf.hover, "Hover Documentation")

	-- Add Format command
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, {})

	-- Document highlighting on cursor hold
	if client and client.server_capabilities.documentHighlightProvider then
		local highlight_augroup = vim.api.nvim_create_augroup("lsp-document-highlight-" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			buffer = bufnr,
			group = vim.api.nvim_create_augroup("lsp-detach-" .. bufnr, { clear = true }),
			callback = function()
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = highlight_augroup })
			end,
		})
	end

	-- Inlay hints (Neovim >= 0.10.0)
	if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		-- Toggle inlay hints with <leader>th
		bufmap("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(bufnr), {
				bufnr = bufnr,
			})
		end, "Toggle Inlay Hints")
	end
end

-- Set up capabilities once, outside of the FileType callbacks
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Create an autocommand group for LSP setup
local lsp_setup_group = vim.api.nvim_create_augroup("LspSetup", { clear = true })

-- Set up Lua LSP only when a Lua file is opened
vim.api.nvim_create_autocmd("FileType", {
	group = lsp_setup_group,
	pattern = "lua",
	callback = function()
		-- Use a flag to ensure we only set up lua_ls once
		if not vim.g.lua_ls_initialized then
			-- Skip lazydev and just configure lua_ls directly for now
			-- We'll debug lazydev separately
			require("lspconfig").lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			vim.g.lua_ls_initialized = true

			-- Try to set up lazydev separately to isolate the error
			-- This way at least lua_ls will work if lazydev fails
			vim.defer_fn(function()
				local status, err = pcall(function()
					require("lazydev").setup({
						library = {
							plugins = { "nvim-dap-ui" },
							types = true,
						},
					})
				end)

				if not status then
					-- Print error to diagnostics
					vim.api.nvim_echo({
						{ "LazyDev setup failed: " .. tostring(err), "ErrorMsg" },
					}, true, {})

					-- Also write to log file for debugging
					vim.fn.writefile(
						{ "LazyDev setup error: " .. tostring(err) },
						vim.fn.stdpath("cache") .. "/lazydev_error.log"
					)
				end
			end, 100) -- Small delay to ensure lua_ls is set up first
		end
	end,
})

-- Set up Nix LSP only when a Nix file is opened
vim.api.nvim_create_autocmd("FileType", {
	group = lsp_setup_group,
	pattern = "nix",
	callback = function()
		-- Use a flag to ensure we only set up nixd once
		if not vim.g.nixd_initialized then
			require("lspconfig").nixd.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			vim.g.nixd_initialized = true
		end
	end,
})
