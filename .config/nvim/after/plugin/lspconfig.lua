local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

-- lua
nvim_lsp.sumneko_lua.setup {
   settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

nvim_lsp.solargraph.setup {
  settings = {
    solargraph = {
      autoformat = false,
      formatting = false,
      completion = true,
      diagnostic = false,
      folding = true,
      references = true,
      rename = true,
      symbols = true
    }
  }
}

vim.keymap.set("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>")
