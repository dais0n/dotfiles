local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

ts.setup {
  ensure_installed = {
    "tsx",
    "toml",
    "ruby",
    "yaml",
    "css",
    "html",
    "lua",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
