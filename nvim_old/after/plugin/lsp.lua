local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)

-- Enable diagnostics UI
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Set diagnostic signs
local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- LSP attach configuration
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gb', "<C-6>")
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    -- Diagnostic navigation
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  end,
})

-- Lua LS setup
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

-- Emmet setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
require('lspconfig').emmet_ls.setup({
  capabilities = capabilities,
  filetypes = {
    "php", "eruby", "html", "javascriptreact", "less", "sass", "scss", "svelte",
    "pug", "typescriptreact", "vue"
  },
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true,
      },
    },
  },
})

-- CSS LS
require('lspconfig').cssls.setup({
  filetypes = { "css", "scss", "html" },
})

-- Clangd setup
require('lspconfig').clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=never",
    "--query-driver=/usr/bin/avr-gcc"
  },
  root_dir = require('lspconfig').util.root_pattern(".clangd", "compile_commands.json", "Makefile"),
  filetypes = { "c", "cpp", "objc", "objcpp" },
})

-- Arduino language server
local MY_FQBN = "esp32:esp32:esp32cam"
require('lspconfig').arduino_language_server.setup({
  cmd = {
    "arduino-language-server",
    "-cli-config", "/home/arturcs/.arduino15/arduino-cli.yaml",
    "-fqbn", MY_FQBN
  }
})

-- Set up completion (cmp)
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  }
})

-- Finish LSP setup
lsp.setup()

-- Mason (LSP installer)
require("mason").setup()
require("mason-lspconfig").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls", "rust_analyzer", "eslint", "vtsls",
    "gopls", "emmet_ls", "clandg"
  },
})

