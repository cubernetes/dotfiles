vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 5
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.list = true
-- optionally add ",eol:$"
vim.opt.listchars = 'tab:> ,trail:-'

vim.opt.updatetime = 50

vim.opt.colorcolumn = '80'

vim.opt.paste = false
vim.opt.splitright = false

-- vim.diagnostic.config({
-- 	virtual_lines = false,
-- 	virtual_text = false,
-- 	underline = false,
-- 	signs = true,
-- })
