--vim.opt: behaves like :set
--vim.opt_global: behaves like :setglobal
--vim.opt_local: behaves like :setlocal

--vim.o: behaves like :set
--vim.go: behaves like :setglobal, like let g: in vim script
--vim.bo: for buffer-scoped options
--vim.wo: for window-scoped options (can be double indexed)

vim.g.mapleader = " "

vim.cmd([[set mouse-=a]])

-- 搜索忽略大小写
vim.opt.ignorecase = true

-- 禁止折行
vim.wo.wrap = false
-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"

vim.o.hidden = true

vim.o.relativenumber = true
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.scrolloff = 10
vim.o.cursorline = true
vim.o.incsearch = true
vim.o.spelllang = "en"
vim.o.clipboard = "unnamedplus"
-- Set updatetime for CursorHold
-- 300ms of no cursor movement to trigger CursorHold
vim.o.updatetime = 300

vim.wo.colorcolumn = "120"
vim.o.fileformats = "unix"

-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,longest,preview,noselect,noinsert,popup"

-- 样式 使neovim支持 termguicolors
vim.o.termguicolors = true
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = "eol:\\u21b5,space:.,tab:>-,trail:-"

vim.cmd.colorscheme("sorbet")
vim.cmd.syntax("on")

vim.g.netrw_winsize = 20
-- 使用增强状态栏插件后不再需要 vim 的模式提示
--vim.o.showmode = false
--------------------------------------------------------------
--- key map
--------------------------------------------------------------
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = true })
vim.keymap.set("n", "<c-h>", "<c-w>h", { silent = true })
vim.keymap.set("n", "<c-j>", "<c-w>j", { silent = true })
vim.keymap.set("n", "<c-k>", "<c-w>k", { silent = true })
vim.keymap.set("n", "<c-l>", "<c-w>l", { silent = true })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = true })
vim.keymap.set("n", "<c-n>", "<cmd>Lex<cr>", { silent = true })

--------------------------------------------------------------
--- auto command
---------------------------------------------------------------
local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
	clear = true,
})

local autocmd = vim.api.nvim_create_autocmd

-- 进入Terminal 自动进入插入模式
autocmd("TermOpen", {
	group = myAutoGroup,
	command = "startinsert",
})
-- 自动保存
autocmd({ "InsertLeave", "TextChanged" }, {
	group = myAutoGroup,
	pattern = { "*" },
	command = "silent! wall",
})

autocmd("BufWritePre", {
	group = myAutoGroup,
	pattern = { "*" },
	callback = function()
		local fn = vim.fn
		local dir = fn.expand("<afile>:p:h")

		-- This handles URLs using netrw. See ':help netrw-transparent' for details.
		if dir:find("%l+://") == 1 then
			return
		end

		if fn.isdirectory(dir) == 0 then
			fn.mkdir(dir, "p")
		end
	end,
})
-- reopen file at the same position
autocmd("BufReadPost", {
	callback = function()
		local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
		if { row, col } ~= { 0, 0 } then
			local max_rows = vim.api.nvim_buf_line_count(0)
			if max_rows < row then
				row = max_rows
			end
			vim.api.nvim_win_set_cursor(0, { row, 0 })
		end
	end,
	group = myAutoGroup,
})

-- 定义一个函数来显示并选择缓冲区
function SelectAndSwitchBuffer()
	-- 获取所有缓冲区的列表
	local bufs = vim.api.nvim_list_bufs()
	local buf_names = {}

	-- 构建缓冲区名称列表
	for _, buf in ipairs(bufs) do
		local bufname = vim.api.nvim_buf_get_name(buf)
		table.insert(buf_names, bufname)
	end

	-- 打印缓冲区列表
	print("Available buffers:")
	for i, bufname in ipairs(buf_names) do
		print(i .. ": " .. bufname)
	end

	-- 获取用户输入的缓冲区编号
	vim.ui.input({ prompt = "Enter buffer number to switch: " }, function(input)
		local choice = tonumber(input)
		if choice and bufs[choice] then
			-- 切换到选择的缓冲区
			vim.api.nvim_set_current_buf(bufs[choice])
		else
			print("Invalid buffer number.")
		end
	end)
end

-- 创建一个命令来调用这个函数
vim.api.nvim_create_user_command("SwitchBuffer", SelectAndSwitchBuffer, {})
vim.keymap.set("n", "<leader>e", "<cmd>SwitchBuffer<cr>", {})

local triggers = { "." }
vim.api.nvim_create_autocmd("InsertCharPre", {
	buffer = vim.api.nvim_get_current_buf(),
	callback = function()
		if vim.fn.pumvisible() == 1 or vim.fn.state("m") == "m" then
			return
		end
		local char = vim.v.char
		if vim.list_contains(triggers, char) then
			local key = vim.keycode("<C-x><C-n>")
			vim.api.nvim_feedkeys(key, "m", false)
		end
	end,
})