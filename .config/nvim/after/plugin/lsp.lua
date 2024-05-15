-- local lsp = require('lsp-zero').preset({})
lsp = require('lsp-zero').preset({
	name = 'minimal',
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = false,
})

lsp.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp.default_keymaps({ buffer = bufnr })
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = 'utf-8'
require('lspconfig').clangd.setup{
	capabilities = capabilities
}

lsp.ensure_installed({
	'clangd',
	'tsserver',
	'eslint',
	'lua_ls',
	'rust_analyzer',
	'html',
	'pyright',
	'jsonls',
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_action = require('lsp-zero').cmp_action()
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-t>'] = cmp.mapping.confirm({ select = true }),
	['<C-Space>'] = cmp.mapping.complete(),
})
--
lsp.set_preferences({
	sign_icons = {}
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()


local null_ls = require('null-ls')
local null_opts = lsp.build_options('null-ls', {})

null_ls.setup({
	on_attach = function(client, bufnr)
		null_opts.on_attach(client, bufnr)
		---
		-- you can add other stuff here....
		---
	end,
	sources = {
		-- Replace these with the tools you have installed
		-- null_ls.builtins.formatting.prettier,
		-- null_ls.builtins.diagnostics.eslint,
		-- null_ls.builtins.formatting.stylua,
	}
})

-- require("norme").setup({
-- 	-- Your configuration
-- 	cmd = os.getenv('HOME') .. '/.local/bin/norminette'
-- })
