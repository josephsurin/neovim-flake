{ pkgs, ... }:

/* lua */ ''
vim.lsp.config('yaml_ls', {
  capabilities = capabilities;
  filetypes = { "yaml" };
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = { "${pkgs.yaml-language-server}/bin/yaml-language-server", "--stdio" },
  handlers = handlers
})
vim.lsp.enable('yaml_ls')
''
