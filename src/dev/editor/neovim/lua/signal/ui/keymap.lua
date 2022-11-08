vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

for key, dir in pairs({ h = '<Left>', j = '<Down>', k = '<Up>', l = '<Right>' }) do
    vim.keymap.set('n', '<A-' .. key .. '>', '<C-w>' .. key, { desc = "move buffer focus " .. dir })
    vim.keymap.set('i', '<A-' .. key .. '>', dir, { desc = "move cursor " .. dir })
end

vim.keymap.set('n', '<H-t>', '<cmd>tabnew<cr>', { desc = "open new tab" })
vim.keymap.set('n', '<H-h>', '<cmd>tabprevious<cr>', { desc = "move cursor to previous tab" })
vim.keymap.set('n', '<H-l>', '<cmd>tabnext<cr>', { desc = "move cursor to next tab" })

vim.keymap.set('n', '<Leader><C-x>', '<cmd>bwipe<cr>', { desc = "wipe buffer" })
