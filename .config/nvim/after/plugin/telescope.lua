local status, telescope = pcall(require, "telescope")
if (not status) then return end

local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    },
  },
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["q"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
}

telescope.load_extension('fzf')
telescope.load_extension("frecency")

vim.keymap.set('n', '<C-r>',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
vim.keymap.set('n', '<C-g>', function()
  builtin.live_grep()
end)
vim.keymap.set("n", "<C-p>", function()
  builtin.oldfiles()
end)
