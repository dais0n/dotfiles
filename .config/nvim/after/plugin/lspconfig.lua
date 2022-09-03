local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

-- lua
nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
    },
  },
}
vim.keymap.set("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>")
