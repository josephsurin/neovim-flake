{ pkgs, ... }:

/* lua */ ''
vim.lsp.config('vimls', {
  capabilities = capabilities;
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = { "${pkgs.nodePackages.vim-language-server}/bin/vim-language-server", "--stdio" },
  handlers = handlers,
})
vim.lsp.enable('vimls')
''
