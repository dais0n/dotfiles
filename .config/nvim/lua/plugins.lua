-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- common utilities
  use 'nvim-lua/plenary.nvim'
  -- packer can manage itself
  use 'wbthomason/packer.nvim'
  -- statusline
  use 'nvim-lualine/lualine.nvim'
  -- markdown
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
  -- lsp
  use 'neovim/nvim-lspconfig'
  -- fuzzy finder
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
end)
