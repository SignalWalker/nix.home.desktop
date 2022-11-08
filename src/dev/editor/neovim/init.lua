vim.opt.runtimepath:append(vim.fn.stdpath('cache'))

-- local i_ok, impatient = pcall(require, 'impatient')
-- local p_ok, _ = pcall(require, 'packer_compiled')
-- if i_ok and p_ok then impatient.enable_profile() end

require('signal.plugins')
require('signal.ui')
require('signal.theme')

vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.backupdir = vim.fn.stdpath('state')..'/backup,.,/tmp'
vim.opt.backupskip:append('*~')

vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

vim.g.python3_host_prog = '/usr/bin/python3'
