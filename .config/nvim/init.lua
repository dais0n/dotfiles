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
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
	{ "kylechui/nvim-surround", version = "*", event = "VeryLazy", config = true },
	{ "mvllow/modes.nvim", config = true },
	{ "nvim-treesitter/nvim-treesitter" },
	{
		"previm/previm",
		config = function()
			vim.g.previm_open_cmd = 'open -a "Google Chrome"'
			vim.g.previm_enable_realtime = 0
			-- clear cache every time we open neovim
			vim.fn["previm#wipe_cache"]()
		end,
		ft = { "markdown" },
	},
	{
		"github/copilot.vim",
		lazy = false,
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
	{ "ojroques/nvim-osc52", config = true },
	{ "numToStr/Comment.nvim", config = true },
	{
		"epwalsh/obsidian.nvim",
		event = "VeryLazy",
		cond = function()
			return vim.loop.os_uname().sysname == "Darwin"
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
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
	-- lsp
	{ "neovim/nvim-lspconfig", event = "LspAttach" },
	{ "hrsh7th/nvim-cmp", event = "InsertEnter" },
	{ "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
	{ "hrsh7th/cmp-buffer", event = "InsertEnter" },
	{ "hrsh7th/cmp-path", event = "InsertEnter" },
	{ "hrsh7th/vim-vsnip", event = "InsertEnter" },
	{ "hrsh7th/cmp-vsnip", event = "InsertEnter" },
	{ "hrsh7th/cmp-cmdline", event = "InsertEnter" },
	{ "williamboman/mason.nvim", cmd = { "Mason", "MasonInstall" } },
	{ "williamboman/mason-lspconfig.nvim", event = "LspAttach" },
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "LspAttach",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{ "j-hui/fidget.nvim", config = true, event = "LspAttach" },
	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		cmd = "Telescope",
		event = "VeryLazy",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	-- git
	{ "lewis6991/gitsigns.nvim", config = true, event = "VeryLazy" },
	{ "ruifm/gitlinker.nvim", event = "VeryLazy", dependencies = { "nvim-lua/plenary.nvim" } },
})

-- plugin settings

--LSP
local lspconfig = require("lspconfig")
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
	set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
	set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
	set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
	set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
	set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"eslint",
		"gopls",
		"lua_ls",
		"tsserver",
	},
})

lspconfig.lua_ls.setup({
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lspconfig.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.sorbet.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] =
	vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

local cmp = require("cmp")
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
		{ name = "buffer" },
		{ name = "path" },
	}),
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "path" },
		{ name = "cmdline", keyword_length = 2 },
	},
})

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown" },
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
	},
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		async = true,
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end
require("null-ls").setup({
	capabilities = capabilities,
	sources = {
		--		require("null-ls").builtins.diagnostics.eslint,
		require("null-ls").builtins.diagnostics.yamllint,
		require("null-ls").builtins.formatting.goimports,
		require("null-ls").builtins.formatting.stylua,
		-- require("null-ls").builtins.formatting.rubocop.with({
		-- 	prefer_local = "bundle_bin",
		-- 	condition = function(utils)
		-- 		return utils.root_has_file({ ".rubocop.yml" })
		-- 	end,
		-- }),
		require("null-ls").builtins.completion.spell,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
})

-- telescope
local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local telescope_actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup({
	extensions = {
		live_grep_args = {
			auto_quoting = true,
			mappings = {
				i = {
					["<C-j>"] = telescope_actions.move_selection_next,
					["<C-k>"] = telescope_actions.move_selection_previous,
					["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t" }),
				},
			},
			theme = "ivy",
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
})
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("file_browser")

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-r>", function()
	telescope_builtin.find_files({
		no_ignore = false,
		hidden = true,
	})
end, opts)
vim.keymap.set("n", "<C-g>", function()
	telescope.extensions.live_grep_args.live_grep_args()
end, opts)
vim.keymap.set("n", "<C-p>", function()
	telescope_builtin.oldfiles()
end, opts)
vim.keymap.set("n", "<C-u>", function()
	telescope.extensions.file_browser.file_browser({ path = "%:p:h", respect_gitignore = false })
end, opts)

-- osc52
local function copy(lines, _)
	require("osc52").copy(table.concat(lines, "\n"))
end

local function paste()
	return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end

vim.g.clipboard = {
	name = "osc52",
	copy = { ["+"] = copy, ["*"] = copy },
	paste = { ["+"] = paste, ["*"] = paste },
}

vim.keymap.set("v", "<leader>c", require("osc52").copy_visual)

-- git
require("gitsigns").setup({
	current_line_blame_formatter = "<abbrev_sha> - <author>, <author_time:%Y-%m-%d> - <summary>",
})

require("gitlinker").setup({
	opts = {
		remote = "upstream", -- force the use of a specific remote
		-- print the url after performing the action
		print_url = false,
	},
})

-- obsidian
local require_obsidian, obsidian = pcall(require, "obsidian")
if require_obsidian then
	obsidian.setup({
		dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/ObsidianVault",
		daily_notes = {
			folder = "dailies",
			date_format = "%Y-%m-%d",
		},
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note with the title 'My new note' will given an ID that looks
			-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,
	})
end

vim.keymap.set("n", "gf", function()
	if require("obsidian").util.cursor_on_markdown_link() then
		return "<cmd>ObsidianFollowLink<CR>"
	else
		return "gf"
	end
end, opts)

-- general
vim.opt.helplang = "ja,en"
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "ucs-boms,utf-8,euc-jp,cp932"
vim.opt.title = true
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.shell = "fish"
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.shell = "/usr/local/bin/zsh"
vim.opt.laststatus = 3
vim.opt.swapfile = false
vim.opt.helpheight = 99999
vim.o.mouse = ""
vim.opt.wrap = true
vim.opt.clipboard = "unnamedplus"

-- highlights
vim.opt.cursorline = false
vim.opt.pumblend = 5
vim.opt.termguicolors = true

-- keymaps
vim.keymap.set("n", "Y", "y$", opts)
vim.keymap.set("v", "v", "$h", opts)

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})
