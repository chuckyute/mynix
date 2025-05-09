local on_attach = function(client, bufnr)
	local bufmap = function(keys, func)
		vim.keymap.set("n", keys, func, { buffer = bufnr })
	end

	bufmap("<leader>r", vim.lsp.buf.rename)
	bufmap("<leader>a", vim.lsp.buf.code_action)

	bufmap("gd", vim.lsp.buf.definition)
	bufmap("gD", vim.lsp.buf.declaration)
	bufmap("gI", vim.lsp.buf.implementation)
	bufmap("<leader>D", vim.lsp.buf.type_definition)

	bufmap("gr", require("telescope.builtin").lsp_references)
	bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols)
	bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols)

	bufmap("K", vim.lsp.buf.hover)

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, {})
	-- Display a notification when the LSP attaches
	vim.notify("LSP '" .. client.name .. "' attached to buffer", vim.log.levels.INFO)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Initialize LSP configuration
local lspconfig = require("lspconfig")

-- Check multiple possible names for the lua language server
local lua_ls_candidates = {
	"lua-language-server", -- Standard name
	"lua_ls", -- Alternative name
	"lua-ls", -- Another alternative name
}

-- Try to find the executable using various methods
local lua_ls_cmd = nil

-- Method 1: Try to find in PATH
for _, name in ipairs(lua_ls_candidates) do
	local path = vim.fn.exepath(name)
	if path ~= "" then
		lua_ls_cmd = path
		break
	end
end

-- Method 2: Check common NixOS store paths
if not lua_ls_cmd then
	-- Use a Lua function to find files in common Nix store locations
	local function find_in_nix_store(pattern)
		local handle =
			io.popen('find /nix/store -path "*' .. pattern .. '" -type f -executable 2>/dev/null | head -n 1')
		if handle then
			local result = handle:read("*a")
			handle:close()
			return result:gsub("[\n\r]", "")
		end
		return nil
	end

	lua_ls_cmd = find_in_nix_store("lua-language-server")
		or find_in_nix_store("bin/lua-language-server")
		or find_in_nix_store("bin/lua_ls")
		or find_in_nix_store("bin/lua-ls")
end

-- Set up Lua LSP if we found the executable
if lua_ls_cmd and lua_ls_cmd ~= "" then
	vim.notify("Using Lua language server: " .. lua_ls_cmd, vim.log.levels.INFO)

	lspconfig.lua_ls.setup({
		cmd = { lua_ls_cmd },
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	})
else
	vim.notify(
		"Could not find lua-language-server executable. Please install it or provide the correct path.",
		vim.log.levels.ERROR
	)

	-- Add a debugging command to help find the path
	vim.api.nvim_create_user_command("FindLuaLS", function()
		local handle = io.popen('find /nix/store -name "lua-language-server" -type f -executable 2>/dev/null')
		if handle then
			local result = handle:read("*a")
			handle:close()
			if result and result ~= "" then
				vim.notify("Found potential lua-language-server executables:\n" .. result, vim.log.levels.INFO)
			else
				vim.notify("No lua-language-server executables found in /nix/store", vim.log.levels.WARN)
			end
		end
	end, {})

	vim.notify("Added :FindLuaLS command to help locate the Lua language server", vim.log.levels.INFO)
end

-- Set up Nix LSP (which is already working)
lspconfig.nixd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
