-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- common utilities
  use 'nvim-lua/plenary.nvim'
  use 'tpope/vim-surround'
  use { 'windwp/nvim-autopairs', config = function() require("nvim-autopairs").setup {} end }
  -- symtax highlight
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- packer can manage itself
  use 'wbthomason/packer.nvim'
  -- theme
  use { 'embark-theme/vim', as = 'embark' }
  -- file icons
  use 'kyazdani42/nvim-web-devicons'
  -- filer
  use 'kyazdani42/nvim-tree.lua'
  -- statusline
  use 'feline-nvim/feline.nvim'
  -- markdown
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/vim-vsnip'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  -- fuzzy finder
  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- git
  use 'lewis6991/gitsigns.nvim'
  use 'tpope/vim-fugitive'
  -- osc52
  use {'ojroques/nvim-osc52', config = function() require('osc52').setup() end }
  -- comment
  use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }
end)
