local on_attach = function(client, bufnr)
	local bufmap = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	-- Essential LSP mappings
	bufmap("<leader>r", vim.lsp.buf.rename, "Rename")
	bufmap("<leader>a", vim.lsp.buf.code_action, "Code Action")

	bufmap("gd", vim.lsp.buf.definition, "Go to Definition")
	bufmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
	bufmap("gI", vim.lsp.buf.implementation, "Go to Implementation")
	bufmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")

	-- Telescope integrations
	bufmap("gr", require("telescope.builtin").lsp_references, "Find References")
	bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
	bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

	-- Documentation & diagnostic helpers
	bufmap("K", vim.lsp.buf.hover, "Hover Documentation")

	-- Format command
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })

	-- Document highlighting on cursor hold
	if client.server_capabilities.documentHighlightProvider then
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
	if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		-- Enable inlay hints by default
		vim.lsp.inlay_hint.enable(bufnr, true)
		-- Toggle inlay hints with <leader>th
		bufmap("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(bufnr), { bufnr = bufnr })
		end, "Toggle Inlay Hints")
	end

	-- Display a notification when the LSP attaches
	vim.notify("LSP '" .. client.name .. "' attached to buffer", vim.log.levels.INFO)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Initialize LSP configuration
local lspconfig = require("lspconfig")

-- Initialize lazydev for Neovim Lua development (safely)
pcall(function()
	require("lazydev").setup({})
end)

-- Set up Lua LSP with the known path
lspconfig.lua_ls.setup({
	-- You can just rely on the lua-language-server package from NixOS
	-- which is already in your PATH thanks to your home.nix configuration
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = {
				globals = {
					"vim",
					"describe",
					"it",
					"before_each",
					"after_each", -- For busted tests
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			completion = {
				callSnippet = "Replace", -- Use snippets for function calls
			},
			telemetry = { enable = false },
		},
	},
})

-- Set up Nix LSP
lspconfig.nixd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

local gd_config = {
	capabilities = capabilities,
	settings = {},
	root_dir = require("lspconfig.util").root_pattern("project.godot", ".git"),
}
if vim.fn.has("win32") == 1 then
	gd_config["cmd"] = { "ncat", "localhost", os.getenv("GDScript_Port") or "6005" }
end
lspconfig.gdscript.setup(gd_config)

-- Helper command to debug LSP status
vim.api.nvim_create_user_command("LspDebug", function()
	local clients = vim.lsp.get_active_clients()
	if #clients == 0 then
		vim.notify("No active LSP clients", vim.log.levels.WARN)
	else
		local msg = "Active LSP clients:\n"
		for i, client in ipairs(clients) do
			local buffers = vim.lsp.get_buffers_by_client_id(client.id)
			local buffer_names = {}
			for _, buf in ipairs(buffers) do
				table.insert(buffer_names, vim.api.nvim_buf_get_name(buf))
			end
			msg = msg
				.. string.format(
					"%d. %s (id: %d) - Attached to: %s\n",
					i,
					client.name,
					client.id,
					table.concat(buffer_names, ", ")
				)
		end
		vim.notify(msg, vim.log.levels.INFO)
	end
end, {})

-- Additional commands for LSP management
vim.api.nvim_create_user_command("LspRestart", function()
	vim.lsp.stop_client(vim.lsp.get_active_clients())
	vim.cmd("edit") -- Refresh the current buffer
end, { desc = "Restart all LSP clients" })

vim.api.nvim_create_user_command("DiagnosticToggle", function()
	local current = vim.diagnostic.config().virtual_text
	if current then
		vim.diagnostic.config({ virtual_text = false })
		vim.notify("Diagnostics virtual text disabled", vim.log.levels.INFO)
	else
		vim.diagnostic.config({ virtual_text = true })
		vim.notify("Diagnostics virtual text enabled", vim.log.levels.INFO)
	end
end, { desc = "Toggle diagnostic virtual text" })
