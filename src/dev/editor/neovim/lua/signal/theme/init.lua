if (vim.g.neovide ~= nil) then
	require('signal.ui.neovide')
end

vim.opt.termguicolors = true

vim.opt.linespace = 0

-- vim.o.background = "dark"

vim.opt.guifont = 'Iosevka:h8'

-- gruvbox
vim.g.gruvbox_material_better_performance = 1

vim.cmd.colorscheme 'everforest'
