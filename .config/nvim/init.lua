-- plugin install
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
 vim.fn.system({
   'git',
   'clone',
   '--filter=blob:none',
   'https://github.com/folke/lazy.nvim.git',
   '--branch=stable',
   lazypath,
 })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  -- common utilities
  {'nvim-lua/plenary.nvim'},
  {'windwp/nvim-autopairs', event = 'InsertEnter'},
  {'renerocksai/telekasten.nvim', cmd = 'Telekasten'},
  {'mvllow/modes.nvim', config = function() require('modes').setup() end},
  -- symtax highlight
  {'nvim-treesitter/nvim-treesitter'},
  -- markdown
  {'iamcco/markdown-preview.nvim', run = function() vim.fn["mkdp#util#install"]() end, cmd = 'MarkdownPreview'},
  -- lsp
  {'neovim/nvim-lspconfig', event = 'LspAttach'},
  {'hrsh7th/nvim-cmp', event = 'InsertEnter'},
  {'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter'},
  {'hrsh7th/cmp-buffer', event = 'InsertEnter'},
  {'hrsh7th/vim-vsnip', event = 'InsertEnter'},
  {'williamboman/mason.nvim', cmd = {'Mason', 'MasonInstall'}},
  {'williamboman/mason-lspconfig.nvim', event = 'LspAttach'},
  -- fuzzy finder
  {'nvim-telescope/telescope.nvim', event = 'VeryLazy'},
  {'nvim-telescope/telescope-file-browser.nvim', event = 'VeryLazy', dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }},
  -- git
  {'lewis6991/gitsigns.nvim', event = 'BufNewFile, BufRead'},
  {'tpope/vim-fugitive'},
  -- osc52
  {'ojroques/nvim-osc52', config = function() require('osc52').setup() end},
  -- comment
  {'numToStr/Comment.nvim', config = function() require('Comment').setup() end},
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
})

-- plugin settings

--LSP
require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server_name)
  local opt = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }
   if server_name == "lua_ls" then
      opt.settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
        }
      }
    end
  require('lspconfig')[server_name].setup(opt)
end })
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

local cmp = require('cmp')
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
})

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  refactor = {
    highlight_defintions = {
      enable = true,
    },
  },
  yati = {
    enable = true,
  },
  matchup = {
    enable = true,
  }
}

-- telescope
local telescope = require('telescope')

local telescope_actions = require('telescope.actions')
local telescope_builtin = require("telescope.builtin")


telescope.setup {
   extensions = {
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = telescope_actions.move_selection_next,
        ["<C-k>"] = telescope_actions.move_selection_previous,
      },
      n = {
        ["q"] = telescope_actions.close,
        ["<C-j>"] = telescope_actions.move_selection_next,
        ["<C-k>"] = telescope_actions.move_selection_previous,
      },
    },
  },
}
telescope.load_extension "file_browser"

vim.keymap.set('n', '<C-r>',
  function()
    telescope_builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
vim.keymap.set('n', '<C-g>', function()
  telescope_builtin.live_grep()
end)
vim.keymap.set("n", "<C-p>", function()
  telescope_builtin.oldfiles()
end)
vim.keymap.set("n", "<C-n>", function()
  telescope.extensions.file_browser.file_browser({
    respect_gitignore = true,
    hidden = true,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)

-- telekasten
local memo_home = vim.fn.expand("~/memo")
require('telekasten').setup({
    home         = memo_home,
    take_over_my_home = true,
    auto_set_filetype = true,

    dailies      = memo_home .. '/' .. 'daily',
    weeklies     = memo_home .. '/' .. 'weekly',
    templates    = memo_home .. '/' .. 'templates',

    image_subdir = "img",

    extension    = ".md",
    new_note_filename = "title",
    uuid_type = "%Y%m%d%H%M",
    uuid_sep = "-",

    follow_creates_nonexisting = true,
    dailies_create_nonexisting = true,
    weeklies_create_nonexisting = true,

    journal_auto_open = false,
    template_new_note = memo_home .. '/' .. 'templates/new_note.md',
    template_new_daily = memo_home .. '/' .. 'templates/daily.md',
    template_new_weekly= memo_home .. '/' .. 'templates/weekly.md',

    image_link_style = "markdown",
    sort = "filename",

    close_after_yanking = false,
    insert_after_inserting = true,

    tag_notation = "#tag",

    command_palette_theme = 'dropdown',
    show_tags_theme = "ivy",

    subdirs_in_links = true,
    template_handling = "smart",
    new_note_location = "smart",
    rename_update_links = true,
})

-- general
vim.opt.helplang = 'ja,en'
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencodings='ucs-boms,utf-8,euc-jp,cp932'
vim.opt.title = true
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.shell = 'fish'
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.shell = '/bin/zsh'
vim.opt.laststatus = 3
vim.opt.swapfile = false

-- highlights
vim.opt.cursorline = false
vim.opt.pumblend = 5
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = { '*' },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})
