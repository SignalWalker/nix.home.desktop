require('signal.ui.keymap')

vim.opt.cursorline = true

vim.opt.backspace = { 'indent', 'eol', 'start' }

vim.opt.showmode = false

vim.opt.signcolumn = 'yes'
vim.opt.modeline = true
vim.opt.number = true
vim.opt.showmatch = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.whichwrap = 'b,s,h,l,<,>,[,]'

vim.opt.wildmenu = true
vim.opt.wildmode = { list = 'longest', 'full' }
vim.opt.virtualedit = 'onemore'
vim.opt.confirm = true

vim.opt.autowriteall = true

vim.opt.scrolljump = 5
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5;

vim.opt.shortmess:append('c')

vim.opt.foldenable = false

vim.opt.tabstop = 3
vim.opt.shiftwidth = 0
vim.opt.softtabstop = -1
vim.opt.expandtab = false
vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.wrap = false
vim.opt.linebreak = true

vim.opt.mouse = 'a'

vim.opt.clipboard:append('unnamedplus')
vim.opt.completeopt = { list = 'menuone', 'noinsert', 'noselect' }
