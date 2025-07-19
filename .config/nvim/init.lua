-- ref: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
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
vim.opt.pumblend = 10 -- popup window size
vim.opt.termguicolors = true -- popup window color
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.mouse = 'a'
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.syntax = "enable"
vim.opt.ttyfast = true
vim.opt.synmaxcol = 2000
vim.opt.modifiable = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clear on pressing <Esc> in normal mode
vim.api.nvim_create_autocmd({ "BufReadPost" }, { -- remember cursor position
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
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
if not vim.loop.fs_stat(lazypath) then
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
    lazy = false,
    priority = 1000,
    ---@type snacks.Config
    opts = {
      indent    = { enabled = true },  -- indent‑blankline 代替
      lazygit   = { enabled = true },  -- lazygit.nvim 代替
      gitbrowse = { enabled = true },  -- gitlinker.nvim 代替

      picker = {
        grep = { live = true },
        files = { hidden = true },
        layout = { preset = "bottom" },
      },
    },

    keys = {
      { "<leader>gy", function() Snacks.gitbrowse() end },
      { "<leader>lg", function() Snacks.lazygit()  end },
      { "<leader>s.", function() Snacks.picker.recent() end },
      { "<leader>sf", function() Snacks.picker.files() end },
      { "<leader>sg", function() Snacks.picker.grep() end },
      { "<leader>sw", function()
          local word = vim.fn.expand("<cword>")
          Snacks.picker.grep({ search = word })
        end
      },
      { "<leader>sd", function() Snacks.picker.diagnostics() end },
      { "<leader>sh", function() Snacks.picker.help()        end },
      { "<leader>sk", function() Snacks.picker.keymaps()     end },
      { "<leader><leader>", function() Snacks.picker.buffers() end },
      { "<leader>b", function() Snacks.picker.lines({ cwd = false }) end},
    },
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim',
        cmd = {
          "Mason",
          "MasonInstall",
          "MasonUninstall",
          "MasonUninstallAll",
          "MasonLog",
          "MasonUpdate",
        },
      },
      { "j-hui/fidget.nvim", tag = "v1.0.0", config = true },
      { "aznhe21/actions-preview.nvim", event="LspAttach" },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf })
          end
          local p = Snacks.picker
          map('gd',          p.lsp_definitions)
          map('gr',          p.lsp_references)
          map('gi',          p.lsp_implementations)
          map('<leader>ld',   p.lsp_type_definitions)
          map('<leader>ls',  p.lsp_symbols)
          map('<leader>ws',  p.lsp_workspace_symbols)
          map('<leader>ca', require("actions-preview").code_actions, '[C]ode [A]ction')
          -- Opens a popup that displays documentation about the word under your cursor
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          client.server_capabilities.document_formatting = true
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      require('mason').setup()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- lua
      require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- typos
      require("lspconfig").typos_lsp.setup({
        init_options = {
          config = '~/.config/typos/.typos.toml',
        },
      })

      -- go
      require('lspconfig').gopls.setup({
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            gofumpt = true,
          },
        },
      })
      -- ref: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports-and-formatting
      vim.api.nvim_create_autocmd("BufWritePre", { -- goimports on save
        pattern = "*.go",
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = {only = {"source.organizeImports"}}
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          vim.lsp.buf.format({async = false})
        end
      })

      -- typescript
      require("lspconfig").ts_ls.setup {
        on_attach = function(client,_)
          client.server_capabilities.documentFormattingProvider = false
        end,
        filetypes = {
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
      }
    end,
  },
  { -- filer
    'stevearc/oil.nvim',
    opts = {},
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        }
      })
      vim.keymap.set("n", "<leader>o", ":Oil<CR>", { noremap = true, silent = true, desc = "[O]pen Current Dir" })
    end
  },
  { 'vim-test/vim-test',
    cmd={"TestNearest", "TestFile"},
    config=function ()
      vim.g['test#strategy'] = 'neovim'
      vim.g['test#neovim#start_normal'] = '1'
      vim.g['test#neovim#term_position'] = 'vert'
    end
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      { "neovim/nvim-lspconfig", event = "InsertEnter" },
      { "hrsh7th/cmp-buffer", event = "InsertEnter" },
      { "hrsh7th/cmp-cmdline", event = "ModeChanged" },
      { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol", event = "InsertEnter" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", event = "InsertEnter" },
      { "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
      { "hrsh7th/cmp-path", event = "InsertEnter" },
      { 'hrsh7th/vim-vsnip', event = 'InsertEnter'},
      { "ray-x/cmp-treesitter", event = "InsertEnter" },
      { "onsails/lspkind.nvim", event = "InsertEnter" }
    },
    config = function()
      -- See `:help cmp`
      require('cmp').setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
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
          { name = "path" },
          { name = "nvim_lsp_signature_help" },
          { name = 'treesitter' },
          { name = "cmdline" },
          { name = 'render-markdown' },
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
      require("mini.statusline").setup()
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'go', 'ruby', 'tsx', 'javascript', 'typescript', 'proto'  },
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby', 'markdown' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts) -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      require('nvim-treesitter.configs').setup(opts)
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
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd("colorscheme nightfox")
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
    event = "VimEnter",
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
})
