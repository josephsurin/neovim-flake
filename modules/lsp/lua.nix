{ pkgs, ... }:

/* lua */ ''
lspconfig.lua_ls.setup{
  settings = {
    runtime = {
      version = "LuaJIT"
    },
    diagnostics = {
      globals = {"vim"}
    },
    workspace = {
      library = vim.api.nvim_get_runtime_file("",true),
    },
    telemetry = {
      enable = false
    },
  };
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${pkgs.sumneko-lua-language-server}/bin/lua-language-server"},
  handlers = handlers,
}
''
