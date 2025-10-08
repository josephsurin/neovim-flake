{ pkgs, ... }:

/* lua */ ''
local html_caps = capabilities
html_caps.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config('html', {
  capabilities = html_caps;
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
  handlers = handlers,
})
vim.lsp.enable('html')
''
