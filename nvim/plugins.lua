require("Comment").setup({})

local telescope_setup = {
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
}

-- Define a factory function for creating LSP configs with home-manager dependencies handled separately
local function create_lsp_config(server, settings)
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
		-- Call server-specific on_attach if it exists
		if settings.on_attach then
			settings.on_attach(client, bufnr)
		end
	end
	local config = function()
		-- Create the common on_attach function
		-- Set up capabilities
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
		-- Run setup function if it exists (like neodev.setup())
		if settings.setup then
			settings.setup()
		end
		-- Set up the LSP server
		require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
			on_attach = on_attach,
			capabilities = capabilities,
		}, settings.server_settings or {}))
	end
	return {
		"neovim/nvim-lspconfig",
		ft = settings.filetypes or { server:match("(.-)_ls$") or server },
		config = config,
	}
end

-- In your lazy.nvim setup:
require("lazy").setup({
	telescope_setup,
	-- Lua LSP
	create_lsp_config("lua_ls", {
		filetypes = { "lua" },
		setup = function()
			require("lazydev").setup()
		end,
		server_settings = {
			root_dir = function()
				return vim.loop.cwd()
			end,
			cmd = { "lua-lsp" },
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		},
	}),
	-- Nix LSP
	create_lsp_config("nixd", {
		filetypes = { "nix" },
		server_settings = {
			-- Any rnix-specific settings
		},
	}),
	-- Add other plugins...
}, {
	install = { missing = false },
})
