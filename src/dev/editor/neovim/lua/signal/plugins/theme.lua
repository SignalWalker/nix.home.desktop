local M = {}

function M.catppuccin()
    require('catppuccin').setup {
		flavor = 'frappe',
        transparent_background = false
    }
end

function M.kanagawa()
	require'kanagawa'.setup {
	}
end

function M.everforest()
	vim.opt.termguicolors = true
	vim.g.everforest_enable_italic = 1
	vim.g.everforest_background = 'soft'
	vim.g.everforest_better_performance = 1
	vim.g.everforest_transparent_background = 1
	vim.g.everforest_ui_contrast = 'low'
end

return M
