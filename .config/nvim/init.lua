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
vim.lsp.config('*', {})
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
        grep = { live = true },
        files = { hidden = true },
        layout = { preset = "bottom" },
      },
    },
    keys = {
      { "<leader>gy", function() require("snacks").gitbrowse() end },
      { "<leader>lg", function() require("snacks").lazygit()  end },
      { "<leader>s.", function() require("snacks").picker.recent() end },
      { "<leader>sf", function() require("snacks").picker.files() end },
      { "<leader>sg", function() require("snacks").picker.grep() end },
      { "<leader>sw", function()
          local word = vim.fn.expand("<cword>")
          require("snacks").picker.grep({ search = word })
        end
      },
      { "<leader>sd", function() require("snacks").picker.diagnostics() end },
      { "<leader>sh", function() require("snacks").picker.help()        end },
      { "<leader>sk", function() require("snacks").picker.keymaps()     end },
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
        default = { 'lsp', 'path', 'buffer' },
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
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'go', 'ruby', 'tsx', 'javascript', 'typescript', 'proto' },
        highlight = { enable = true },
      }
    end,
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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_clients({ id = ev.data.client_id })[1]
    if not client then return end

    local bufnr = ev.buf
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
    map('gd', function() require('snacks').picker.lsp_definitions() end,      'Go to Definition')
    map('gr', function() require('snacks').picker.lsp_references() end,      'References')
    map('gi', function() require('snacks').picker.lsp_implementations() end, 'Implementations')
    map('gt', function() require('snacks').picker.lsp_type_definitions() end, 'Type Definition')
    map('K',  vim.lsp.buf.hover,          'Hover')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map('<leader>rn', vim.lsp.buf.rename,      'Rename')
    map('<leader>f',  function() vim.lsp.buf.format({ async = true }) end, 'Format')
    map('<leader>ss', function() require('snacks').picker.lsp_symbols() end, 'LSP Symbols')

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client.name == 'typescript-tools' then
      client.server_capabilities.documentFormattingProvider = false
    end

  end,
})

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    if ev.data and ev.data.params then
      local val = ev.data.params.value
      if val and val.kind == 'end' then
        local client = vim.lsp.get_clients({ id = ev.data.client_id })[1]
        if client then
          vim.notify(client.name .. ': indexing complete', vim.log.levels.INFO)
        end
      end
    end
  end,
})

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings = {
    gopls = {
      analyses = { unusedparams = true, nilness = true, unusedwrite = true, shadow = true },
      gofumpt   = true,
    },
  },
})

vim.lsp.config('typos_lsp', {
  cmd = { 'typos-lsp'},
  init_options = { config = vim.fn.expand('~/.config/typos/.typos.toml') },
})

vim.lsp.config('ruby_lsp', {
  cmd = { 'ruby-lsp' },
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  single_file_support = true,
  init_options = {
    indexing = {
      excludedPatterns = {
        '**/vendor/**',
        '**/tmp/**',
        '**/log/**',
        '**/node_modules/**',
        '**/public/**',
        '**/spec/**',
      },
    },
    enabledFeatures = {
      diagnostics = false,
    },
  },
})

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', '.clangd', '.git' },
})

vim.lsp.enable({ 'lua_ls', 'gopls', 'ruby_lsp', 'typos_lsp', 'clangd' })

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local client = vim.lsp.get_clients({ id = cid })[1]
          local enc = client and client.offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})
