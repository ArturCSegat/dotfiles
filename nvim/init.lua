vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", ":Oil<CR>")
vim.opt.virtualedit= 'all'

vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.signcolumn = "yes"

vim.opt.wrap = false 
vim.opt.tabstop = 8

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>y", "\"+y")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
require("extra")

function prompt_and_run(cmd_name)
	vim.ui.input({ prompt = cmd_name .. " args: " }, function(input)
		if input then
			vim.cmd(cmd_name .. " " .. input)
		end
	end)
end

-- For visual and insert mode
vim.keymap.set("n", "<leader>fo", function()
	prompt_and_run("For")
end)

vim.keymap.set("n", "<leader>lo", function()
	prompt_and_run("Log")
end)

-- Define <leader>w{key} mappings to match <C-w>{key}
local opts = { noremap = true, silent = true }
local map = vim.keymap.set
map("n", "<leader>h", "<C-w>h", opts)  -- move to left window
map("n", "<leader>l", "<C-w>l", opts)  -- move to right window
map("n", "<leader>j", "<C-w>j", opts)  -- move to below window
map("n", "<leader>k", "<C-w>k", opts)  -- move to above window
map("n", "<leader>wv", "<C-w>v", opts) -- vertical split
map("n", "<leader>ws", "<C-w>s", opts) -- horizontal split
map("n", "<leader>wc", "<C-w>c", opts) -- close window
map("n", "<leader>wo", "<C-w>o", opts) -- close other windows
map("n", "<leader>w=", "<C-w>=", opts) -- equalize window sizes
map("n", "<leader>ww", "<C-w>w", opts) -- switch to next window
map("n", "<leader>wp", "<C-w>p", opts) -- switch to previous window
map("n", "<leader>wr", "<C-w>r", opts) -- rotate windows

vim.pack.add({
	{ src = 'https://github.com/williamboman/mason.nvim' },
	{ src = "https://github.com/mbbill/undotree" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = 'https://github.com/hrsh7th/nvim-cmp' },
	{ src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
	{ src = "https://github.com/github/copilot.vim" },
	{ src = "https://github.com/3rd/image.nvim" },
})


vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

require "oil".setup()
require "image".enable()

require("image").setup({
	integrations = {
		markdown = {
			only_render_image_at_cursor = true, -- defaults to false
			only_render_image_at_cursor_mode = "popup", -- "popup" or "inline", defaults to "popup"
		}
	}
})

require "mini.pick".setup()
map('n', '<leader>sf', ":Pick files<CR>")
vim.keymap.set('n', '<leader>ps', function()
	vim.ui.input({ prompt = "Grep > " }, function(input)
		if input and input ~= "" then
			require("mini.pick").builtin.cli({
				command = { "grep", "-rnI", input, "." },
				preview = "bat --style=numbers --color=always --line-range=:100 {}",
			})
		end
	end)
end)

require("mason").setup()

-- Setup mason-lspconfig
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"gopls",
		"emmet_ls",
		"clangd",
		"vtsls",
		"vue_ls",
	},
	automatic_installation = true,
})

-- Get lspconfig and capabilities
local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Define on_attach
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
end

-- Configure vtsls FIRST
lspconfig.vtsls.setup({
	filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx", "vue" },
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Configure other servers
lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }
			}
		}
	}
})

lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.emmet_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "css", "vue" },
})
local cmp = require("cmp")

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-Space>'] = cmp.mapping.complete(),
	}),
	sources = {
		{ name = 'nvim_lsp' },
	},
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, {})

vim.diagnostic.config({
	virtual_text = true, -- Show inline errors
	signs = true,       -- Show signs in gutter
	underline = true,   -- Underline the problematic code
	update_in_insert = false, -- Don't show errors while typing
	severity_sort = true, -- Sort by severity
})

vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', {
	expr = true,
	replace_keycodes = false
})
