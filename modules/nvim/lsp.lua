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
	-- API: enable(bufnr, enable) — bufnr is first argument
	if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		bufmap("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end, "Toggle Inlay Hints")
	end
	-- Display a notification when the LSP attaches
	vim.notify("LSP '" .. client.name .. "' attached to buffer", vim.log.levels.INFO)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local lspconfig = require("lspconfig")

pcall(function()
	require("lazydev").setup({})
end)

lspconfig.lua_ls.setup({
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
					"after_each",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			completion = {
				callSnippet = "Replace",
			},
			telemetry = { enable = false },
		},
	},
})

lspconfig.nixd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.gdscript.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "gd", "gdscript" },
	root_dir = require("lspconfig.util").root_pattern("project.godot", ".git"),
	cmd = { "nc", "localhost", "6005" },
})

-- Debug: show active LSP clients and their attached buffers
vim.api.nvim_create_user_command("LspDebug", function()
	local clients = vim.lsp.get_clients()
	if #clients == 0 then
		vim.notify("No active LSP clients", vim.log.levels.WARN)
	else
		local msg = "Active LSP clients:\n"
		for i, client in ipairs(clients) do
			local buffer_names = {}
			for buf in pairs(client.attached_buffers) do
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

-- Restart all LSP clients for current buffer
vim.api.nvim_create_user_command("LspRestart", function()
	for _, client in ipairs(vim.lsp.get_clients()) do
		client:stop()
	end
	vim.cmd("edit")
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
