{ pkgs, ... }:

/* lua */ ''
lspconfig.ts_ls.setup{
  capabilities = capabilities;
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" },
  handlers = handlers
}

lspconfig.svelte.setup{
  capabilities = capabilities;
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = { "${pkgs.nodePackages.svelte-language-server}/bin/svelteserver", "--stdio" },
  handlers = handlers,
}
''
