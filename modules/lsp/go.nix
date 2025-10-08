{ pkgs, ... }:

/* lua */ ''
vim.lsp.config('gopls', {
    capabilities = capabilities;
    on_attach = default_on_attach;
    cmd = {"${pkgs.gopls}/bin/gopls", "serve"},
})
vim.lsp.enable('gopls')
''
