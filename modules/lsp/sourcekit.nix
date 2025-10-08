{ config, pkgs, ... }:

/* lua */ ''
local sk_capabilities = vim.lsp.protocol.make_client_capabilities()
-- enable pull diagnostics
sk_capabilities["textDocument"]["diagnostic"]["dynamicRegistration"] = true
vim.lsp.config('sourcekit', {
  capabilities = sk_capabilities;
  on_attach = default_on_attach;
  filetypes = {"swift"};
  cmd = {"${config.vim.lsp.languages.sourcekit-cmd}"},
  handlers = handlers,
})
vim.lsp.enable('sourcekit')
''
