{ pkgs, ... }:

/* lua */ ''
vim.lsp.config('ts_ls', {
  capabilities = capabilities;
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" },
  handlers = handlers
})
vim.lsp.enable('ts_ls')

vim.lsp.config('svelte', {
  capabilities = capabilities;
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = { "${pkgs.nodePackages.svelte-language-server}/bin/svelteserver", "--stdio" },
  handlers = handlers,
})
vim.lsp.enable('svelte')
''
