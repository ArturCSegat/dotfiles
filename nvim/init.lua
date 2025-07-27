vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", ":Oil<CR>")

vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.signcolumn = "yes"

vim.opt.wrap = true
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
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
require("extra")

-- Define <leader>w{key} mappings to match <C-w>{key}
local opts = { noremap = true, silent = true }
local map = vim.keymap.set
map("n", "<leader>h", "<C-w>h", opts) -- move to left window
map("n", "<leader>l", "<C-w>l", opts) -- move to right window
map("n", "<leader>j", "<C-w>j", opts) -- move to below window
map("n", "<leader>k", "<C-w>k", opts) -- move to above window
map("n", "<leader>wv", "<C-w>v", opts) -- vertical split
map("n", "<leader>ws", "<C-w>s", opts) -- horizontal split
map("n", "<leader>wc", "<C-w>c", opts) -- close window
map("n", "<leader>wo", "<C-w>o", opts) -- close other windows
map("n", "<leader>w=", "<C-w>=", opts) -- equalize window sizes
map("n", "<leader>ww", "<C-w>w", opts) -- switch to next window
map("n", "<leader>wp", "<C-w>p", opts) -- switch to previous window
map("n", "<leader>wr", "<C-w>r", opts) -- rotate windows

vim.pack.add({
	{ src= 'https://github.com/williamboman/mason.nvim'},
	{ src= "https://github.com/mbbill/undotree" },
	{ src= 'https://github.com/neovim/nvim-lspconfig'},
	{ src= "https://github.com/stevearc/oil.nvim"},
	{ src= "https://github.com/echasnovski/mini.pick"},
	{ src = 'https://github.com/hrsh7th/nvim-cmp' },
	{ src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
})

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

require "oil".setup()

require "mini.pick".setup()
map('n', '<leader>sf', ":Pick files<CR>")

require "mason".setup()
require("mason-lspconfig").setup()

ensure_installed = {
    "lua_ls", "rust_analyzer", "eslint", "vtsls",
    "gopls", "emmet_ls", "clangd"
  }
require("mason-lspconfig").setup({
	ensure_installed
})
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")
vim.lsp.enable(ensure_installed)

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




