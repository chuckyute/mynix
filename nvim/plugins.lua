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
