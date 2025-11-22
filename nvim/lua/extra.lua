-- Global table to store tab names
_G.tab_names = _G.tab_names or {}
local opts = { noremap = true, silent = true }
local map = vim.keymap.set


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

function ColorMyPencils(color)
	color = color or "habamax"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, 'Normal',         { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'NormalNC',       { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'NormalFloat',    { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'FloatBorder',    { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'Pmenu',          { bg = 'none', ctermbg = 'none' })
	-- vim.api.nvim_set_hl(0, 'PmenuSel',       { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'PmenuSbar',      { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'PmenuThumb',     { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'SignColumn',     { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'VertSplit',      { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'StatusLine',     { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'StatusLineNC',   { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'LineNr',         { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'CursorLineNr',   { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'TabLine',        { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'TabLineFill',    { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'TabLineSel',     { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'WinSeparator',   { bg = 'none', ctermbg = 'none' })
	vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none', ctermbg = 'none' })
end

ColorMyPencils()

vim.api.nvim_create_user_command("For", function(opts)
	local args = vim.split(opts.args, "%s+")
	local i = args[1]
	local N = args[2]
	if not N then
		print("Usage: :For <i> <n>")
		return
	end

	local filetype = vim.bo.filetype
	local loop_code = {}
	local indent = "    "  -- 4 spaces

	if filetype == "lua" then
		table.insert(loop_code, string.format("for %s = 0, %s - 1 do", i, N))
		table.insert(loop_code, indent .. "-- body")
		table.insert(loop_code, "end")

	elseif filetype == "python" then
		table.insert(loop_code, string.format("for %s in range(%s):", i, N))
		table.insert(loop_code, indent .. "# body")

	elseif filetype == "javascript" or filetype == "typescript" then
		table.insert(loop_code, string.format("for (let %s = 0; %s < %s; %s++) {", i, i, N, i))
		table.insert(loop_code, indent .. "// body")
		table.insert(loop_code, "}")

	elseif filetype == "go" then
		table.insert(loop_code, string.format("for %s := 0; %s < %s; %s++ {", i, i, N, i))
		table.insert(loop_code, indent .. "// body")
		table.insert(loop_code, "}")

	elseif filetype == "c" or filetype == "cpp" then
		table.insert(loop_code, string.format("for (int %s = 0; %s < %s; %s++) {", i, i, N, i))
		table.insert(loop_code, indent .. "// body")
		table.insert(loop_code, "}")

	else
		table.insert(loop_code, string.format("-- unsupported filetype for :For %s", i, N))
	end

	local linenr = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, linenr, linenr, false, loop_code)
end, {
nargs = 1,
desc = "Insert a for loop from i=0 to N-1",
})


vim.api.nvim_create_user_command("Log", function(opts)
	local args = vim.split(opts.args, "%s+")
	local expr = args[1]
	if not expr then
		print("Usage: :Log <name>")
		return
	end

	local filetype = vim.bo.filetype

	if filetype == "javascript" or filetype == "typescript" or filetype == "javascriptreact" or filetype == "typescriptreact" then
		log_line = string.format('console.log("%s: ", %s);', expr, expr)
	elseif filetype == "lua" then
		log_line = string.format('print("%s: ", %s)', expr, expr)
	elseif filetype == "python" then
		log_line = string.format('print(f"%s: {%s}")', expr, expr)
	elseif filetype == "go" then
		log_line = string.format('fmt.Println("%s:", %s)', expr, expr)
	elseif filetype == "rust" then
		log_line = string.format('println!("{}: {:?}", %s);', expr)
	elseif filetype == "c" or filetype == "cpp" then
		log_line = string.format('printf("%s: %%d\\n", %s);', expr, expr)
	else 
		print("Not supported")
	end
	local linenr = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, linenr, linenr, false, { log_line })
end, {
	nargs = 1,
	desc = "insert a log for the variable",
})


