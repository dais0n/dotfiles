require("nvim-tree").setup()
vim.keymap.set({'n', 'i'}, '<C-n>', '<cmd>NvimTreeFindFileToggle<cr>', { noremap = true })
