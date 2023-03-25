local opts = { noremap=true, silent=true }
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
  {'windwp/nvim-autopairs', event = 'InsertEnter', config = true},
  {'mvllow/modes.nvim', config = true},
  -- terminal
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  -- symtax highlight
  {'nvim-treesitter/nvim-treesitter'},
  -- markdown
  {
    'previm/previm',
    config = function()
      vim.g.previm_open_cmd = 'open -a \"Google Chrome Beta\"';
      vim.g.previm_enable_realtime = 0
      -- clear cache every time we open neovim
      vim.fn["previm#wipe_cache"]()
    end,
    ft = { "markdown" }
  },
  -- lsp
  {'neovim/nvim-lspconfig', event = 'LspAttach'},
  {'hrsh7th/nvim-cmp', event = 'InsertEnter'},
  {'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter'},
  {'hrsh7th/cmp-buffer', event = 'InsertEnter'},
  {'hrsh7th/cmp-path', event = 'InsertEnter'},
  {'hrsh7th/vim-vsnip', event = 'InsertEnter'},
  {'hrsh7th/cmp-vsnip', event = 'InsertEnter'},
  {'hrsh7th/cmp-cmdline', event = 'InsertEnter'},
  {'williamboman/mason.nvim', cmd = {'Mason', 'MasonInstall'}},
  {'williamboman/mason-lspconfig.nvim', event = 'LspAttach'},
  {'jose-elias-alvarez/null-ls.nvim', event = 'LspAttach', dependencies = { "nvim-lua/plenary.nvim" }},
  -- telescope
  {'nvim-telescope/telescope.nvim', event = 'VeryLazy', dependencies = { "nvim-telescope/telescope-live-grep-args.nvim" }},
  {"nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }},
  -- git
  {'lewis6991/gitsigns.nvim', event = 'BufNewFile, BufRead'},
  {'tpope/vim-fugitive'},
  -- osc52
  {'ojroques/nvim-osc52', config = true, event = 'BufNewFile, BufRead'},
  -- comment
  {'numToStr/Comment.nvim', config = true},
  -- theme
  {
    "sainnhe/gruvbox-material",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
})

-- plugin settings

--LSP
local on_attach = function(client, bufnr)
  local set = vim.keymap.set
  set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
  set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
  set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
  set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
  set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
  set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
  set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
  set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(
vim.lsp.protocol.make_client_capabilities()
)
require('mason').setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls" },
    automatic_installation = true
}
require('mason-lspconfig').setup_handlers({ function(server_name)
  local opt = {
    on_attach = on_attach,
    capabilities = capabilities
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
      ['<C-f>'] = cmp.mapping.scroll_docs(-4),
      ['<C-b>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      { name = "buffer" },
      { name = "path" }
    })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = {
    { name = 'path' },
    { name = 'cmdline' , keyword_length = 2},
  },
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

require('null-ls').setup({
 capabilities = capabilities,
  sources = {
    require('null-ls').builtins.formatting.stylua,
    require('null-ls').builtins.diagnostics.rubocop.with({
      prefer_local = "bundle_bin",
      condition = function(utils)
        return utils.root_has_file({".rubocop.yml"})
      end
    }),
    require('null-ls').builtins.diagnostics.eslint,
    -- require('null-ls').builtins.diagnostics.luacheck.with({
    --   extra_args = {"--globals", "vim", "--globals", "awesome"},
    -- }),
    require('null-ls').builtins.diagnostics.yamllint,
    require('null-ls').builtins.formatting.gofmt,
    require('null-ls').builtins.formatting.rustfmt,
    require('null-ls').builtins.formatting.rubocop.with({
      prefer_local = "bundle_bin",
      condition = function(utils)
        return utils.root_has_file({".rubocop.yml"})
      end
    }),
    require('null-ls').builtins.completion.spell,
  },
})

-- telescope
local telescope = require('telescope')
local telescope_builtin = require("telescope.builtin")
local telescope_actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup {
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-j>"] = telescope_actions.move_selection_next,
          ["<C-k>"] = telescope_actions.move_selection_previous,
          ["<C-t>"] = lga_actions.quote_prompt({ postfix = ' -t' })
        },
      },
      theme = "ivy"
    },
     file_browser = {
      theme = "ivy",
      dir_icon = "",
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
  pickers = {
    find_files = {
      theme = "ivy",
    },
    oldfiles = {
      theme = "ivy",
    },
    live_grep = {
      theme = "ivy",
    },
  },
}
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("file_browser")

vim.keymap.set('n', '<C-r>',
  function()
    telescope_builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end,opts)
vim.keymap.set('n', '<C-g>', function()
  telescope.extensions.live_grep_args.live_grep_args()
end,opts)
vim.keymap.set("n", "<C-p>", function()
  telescope_builtin.oldfiles()
end,opts)

-- toggleterm
local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

-- osc52
function copy()
  require('osc52').copy_register('c')
end

vim.api.nvim_create_autocmd('TextYankPost', {callback = copy})
vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)

vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true",
  { noremap = true }
)

vim.api.nvim_command('command! OpenCurrentDir Telescope file_browser path=%:p:h select_buffer=tru')

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
vim.opt.shell = '/usr/local/bin/zsh'
vim.opt.laststatus = 3
vim.opt.swapfile = false
vim.opt.helpheight=99999
vim.o.mouse = ''

-- highlights
vim.opt.cursorline = false
vim.opt.pumblend = 5
vim.opt.termguicolors = true

-- keymaps
vim.keymap.set("n", "Y", "y$", opts)
vim.keymap.set("v", "v", "$h", opts)

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = { '*' },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})
