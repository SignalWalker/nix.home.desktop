return function()
	vim.g.neo_tree_remove_legacy_commands = 1
	require'neo-tree'.setup{

	}
    vim.keymap.set('n', '<Leader>tt', '<cmd>NvimTreeToggle<cr>', { desc = 'nvim-tree toggle' })
    vim.keymap.set('n', '<Leader>tf', '<cmd>NvimTreeFindFile<cr>', { desc = 'nvim-tree find file' })
end
