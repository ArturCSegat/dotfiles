vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", ":Oil<CR>")
vim.o.background = "dark" -- or "light" for light mode
-- vim.cmd([[colorscheme gruvbox]])

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.wrap = false

vim.opt.tabstop = 4

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "<C-o>", "o<esc>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Global table to store tab names
_G.tab_names = _G.tab_names or {}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Create a new tabpage with the current buffer
map("n", "<leader>tn", function()
  vim.cmd("tab split")
end, opts)

-- Delete the current tabpage
map("n", "<leader>tr", ":tabclose<CR>", opts)

-- Rename current tabpage
map("n", "<leader>trn", function()
  local tabnr = vim.api.nvim_get_current_tabpage()
  vim.ui.input({ prompt = "New tab name: " }, function(input)
    if input then
      _G.tab_names[tabnr] = input
      vim.cmd("redrawtabline")
    end
  end)
end, opts)

-- Go to tabpages 1 through 9
for i = 1, 9 do
  map("n", "<leader>" .. i, i .. "gt", opts)
end

-- Optional: Custom tabline to show names
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.TabLine()"

function _G.TabLine()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local filename = vim.fn.fnamemodify(bufname, ":t")
    local label

    if _G.tab_names[i] then
      label = _G.tab_names[i]
    else
      if filename == "" then
        label = "No Name:" .. i
      else
        label = filename .. ":" .. i
      end
    end

    -- Add square brackets to active tab label
    if i == vim.fn.tabpagenr() then
      label = "[" .. label .. "]"
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    s = s .. "%" .. i .. "T" .. " " .. label .. " "
  end
  s = s .. "%#TabLineFill#"
  return s
end


-- Define <leader>w{key} mappings to match <C-w>{key}
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

