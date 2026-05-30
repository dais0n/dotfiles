-- ref: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
vim.loader.enable()
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.exrc = true
vim.opt.number = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.swapfile = false
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.smoothscroll = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.autowrite = true
vim.opt.clipboard = 'unnamedplus'
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clear on pressing <Esc> in normal mode
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    pcall(function() vim.cmd('silent! normal! g`"zv') end)
  end,
})

vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<Space>v', '<C-v>', { desc = '矩形選択' })

vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = '●' },
  float = { border = 'rounded', source = true },
  severity_sort = true,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- plugin install
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  { -- Fuzzy finder
    "folke/snacks.nvim",
    event = 'VeryLazy',
    opts = {
      indent    = { enabled = true },
      lazygit   = { enabled = true },
      gitbrowse = { enabled = true },
      notifier  = { enabled = true },
      quickfile = { enabled = true },
      bigfile   = { enabled = true },
      words     = { enabled = true },
      input     = { enabled = true },

      picker = {
        layout = { preset = "bottom" },
        sources = {
          grep = { live = true, hidden = true },
          files = { hidden = true },
        },
      },
    },
    keys = {
      { "<leader>gy", function() require("snacks").gitbrowse() end },
      { "<leader>lg", function() require("snacks").lazygit()  end },
      { "<leader>s.", function() require("snacks").picker.recent() end },
      { "<leader>sf", function() require("snacks").picker.files() end },
      { "<leader>sg", function() require("snacks").picker.grep() end },
      { "<leader>sw", function() require("snacks").picker.grep_word() end },
      { "<leader>sd", function() require("snacks").picker.diagnostics() end },
      { "<leader>sh", function() require("snacks").picker.help()        end },
      { "<leader>sk", function() require("snacks").picker.keymaps()     end },
      { "<leader>ss", function() require("snacks").picker.treesitter()  end },
      { "<leader>sr", function() require("snacks").picker.resume()      end },
      { "<leader>gs", function() require("snacks").picker.git_status()   end },
      { "<leader>gl", function() require("snacks").picker.git_log_file() end },
      { "<leader>gb", function() require("snacks").picker.git_branches() end },
      { "<leader><leader>", function() require("snacks").picker.buffers() end },
      { "<leader>b", function() require("snacks").picker.lines({ cwd = false }) end},
    },
  },
  { -- filer
    'stevearc/oil.nvim',
    cmd = 'Oil',
    keys = {
      { "<leader>o", function() require("oil").open() end, desc = "Oil" },
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      sources = {
        default = { 'path', 'buffer' },
      },
      cmdline = { enabled = true },
      completion = {
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= 'cmdline' or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
          end,
        },
        documentation = { auto_show = true },
      },
      signature = { enabled = true },
    },
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
      require("mini.pairs").setup()
      require("mini.icons").setup()
      require("mini.statusline").setup()
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'go', 'ruby', 'tsx', 'javascript', 'typescript', 'proto' },
      highlight = { enable = true },
    },
  },
  { -- sticky context (関数/クラスを上部に固定)
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'BufRead',
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
    },
    keys = {
      { "<leader>tc", "<cmd>TSContextToggle<CR>", desc = "Toggle treesitter context" },
    },
  },
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme catppuccin")
    end
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
    ft = { "markdown" },
    keys = {
      { "<Space>sm", ":RenderMarkdown toggle<CR>" },
    },
    opts = {
      heading = {
        width = "block",
        left_pad = 0,
        right_pad = 4,
        icons = {},
      },
      code = {
        width = "block",
      },
    }
  },
  { "kevinhwang91/nvim-bqf", ft = 'qf' }, -- quickfix preview
  { "sebdah/vim-delve", ft = 'go', config = function()
    vim.api.nvim_create_user_command(
      'DlvDebugWorkspace',
      function()
        vim.cmd(string.format('DlvDebug --build-flags="-gcflags=\'all=-N -l\'" %s', vim.fn.getcwd()))
      end,
      { nargs = 0 }
    )
  end
  },
}, {
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

