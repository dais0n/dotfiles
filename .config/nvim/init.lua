-- ref: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
vim.loader.enable()
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
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
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clear on pressing <Esc> in normal mode
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    pcall(function() vim.cmd('silent! normal! g`"zv') end)
  end,
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

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
    priority = 1000,
    opts = {
      indent    = { enabled = true },
      lazygit   = { enabled = true },
      gitbrowse = { enabled = true },

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
  { 'j-hui/fidget.nvim', tag = 'v1.0.0', event = 'LspAttach', config = true },
  { -- filer
    'stevearc/oil.nvim',
    cmd = 'Oil',
    keys = {
      { "<leader>o", "<cmd>Oil<CR>", desc = "Oil" },
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      { "hrsh7th/cmp-buffer", event = "InsertEnter" },
      { "hrsh7th/cmp-cmdline", event = "CmdlineEnter" },
      { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", event = "InsertEnter" },
      { "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
      { "hrsh7th/cmp-path", event = "InsertEnter" },
      { "onsails/lspkind.nvim", event = "InsertEnter" }
    },
    config = function()
      -- See `:help cmp`
      require('cmp').setup {
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = require('cmp').mapping.preset.insert {
          ['<C-n>'] = require('cmp').mapping.select_next_item(),
          ['<C-p>'] = require('cmp').mapping.select_prev_item(),
          ['<C-b>'] = require('cmp').mapping.scroll_docs(-4),
          ["<C-y>"] = require('cmp').mapping.confirm { select = true },
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = "buffer" },
          { name = "nvim_lsp_signature_help" },
          { name = 'nvim_lua' },
          { name = "cmdline" },
        },
        formatting = {
          format = require("lspkind").cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            preset = 'codicons',
            maxwidth = 50,
            menu = {
              nvim_lsp = "[LSP]",
              cmdline = "[CL]",
              buffer = "[BUF]",
              path = "[PH]",
              treesitter = "[TS]",
            },
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
          })
        }
      }
      require('cmp').setup.cmdline("/", {
        mapping = require('cmp').mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      require('cmp').setup.cmdline(":", {
        mapping = require('cmp').mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
        },
      })
    end,
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
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    event = 'BufRead',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {}
      -- Install parsers
      local parsers = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'go', 'ruby', 'tsx', 'javascript', 'typescript', 'proto', 'latex' }
      require('nvim-treesitter').install(parsers)
      -- Enable treesitter highlighting
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local ok, parser = pcall(vim.treesitter.get_parser, 0, vim.bo.filetype)
          if ok and parser then
            vim.treesitter.start()
          end
        end,
      })
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
    "previm/previm",
    ft = { "markdown", "asciidoc" },
    dependencies = {
      "tyru/open-browser.vim",
    },
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
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set(
        "i",
        "<C-f>",
        'copilot#Accept("<CR>")',
        { silent = true, expr = true, script = true, replace_keycodes = false }
      )
      vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)")
      vim.keymap.set("i", "<C-o>", "<Plug>(copilot-dismiss)")
      vim.keymap.set("i", "<C-g>", "<Plug>(copilot-suggest)")
    end,
  },
  { "kevinhwang91/nvim-bqf", ft = 'qf' }, -- quickfix preview
  { "thinca/vim-qfreplace", ft = 'qf' },
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

    -- lazy load cmp_nvim_lsp capabilities on first attach
    if not vim.g._lsp_capabilities_set then
      vim.g._lsp_capabilities_set = true
      local capabilities = vim.tbl_deep_extend('force',
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )
      vim.lsp.config('*', { capabilities = capabilities })
    end
    local bufnr = ev.buf
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
    map('gd', vim.lsp.buf.definition,     'Go to Definition')
    map('gr', vim.lsp.buf.references,     'References')
    map('gi', vim.lsp.buf.implementation, 'Implementations')
    map('K',  vim.lsp.buf.hover,          'Hover')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map('<leader>rn', vim.lsp.buf.rename,      'Rename')

    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client.name == 'tsserver' then
      client.server_capabilities.documentFormattingProvider = false
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
      analyses = { unusedparams = true },
      gofumpt   = true,
    },
  },
})

vim.lsp.config('tsserver', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  root_markers = { 'package.json', 'tsconfig.json', '.git' },
})

vim.lsp.config('typos_lsp', {
  cmd = { 'typos-lsp'},
  init_options = { config = vim.fn.expand('~/.config/typos/.typos.toml') },
})

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', '.clangd', '.git' },
})

vim.lsp.enable({ 'lua_ls', 'gopls', 'tsserver', 'typos_lsp', 'clangd' })

-- .claude filetype: @ key opens file picker and inserts path
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.claude',
  callback = function(ev)
    vim.keymap.set('i', '@', function()
      require('snacks').picker.files({
        cwd = vim.env.HOME,
        confirm = function(picker, item)
          picker:close()
          if item then
            vim.schedule(function()
              vim.api.nvim_put({ item.file .. ' ' }, 'c', true, true)
            end)
          end
        end,
      })
    end, { buffer = ev.buf })
  end,
})

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
