{ pkgs, lib ? pkgs.lib, ... }:

{ config }:

let
  inherit (vimOptions.config) vim;

  vimOptions = lib.evalModules {
    modules = [
      { imports = [ ../modules ]; }
      config
    ];

    specialArgs = { inherit pkgs; };
  };

  # Source: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/neovim.nix
  runtime' = lib.filter (f: f.enable) (lib.attrValues {});

  runtime = pkgs.linkFarm "neovim-runtime" (map (x: { name = "etc/${x.target}"; path = x.source; }) runtime');
in
rec {
  luaRC = pkgs.writeTextFile {
    name = "init.lua";
    text = ''
      ${vim.startLuaConfigRC}
      ${vim.luaConfigRC}
    '';
  };

  neovimRC = pkgs.writeTextFile {
    name = "init.vim";
    text = ''
      ${vim.finalConfigRC}
    '';
  };

  finalConfigRC = ''
    ${vim.finalConfigRC}

    " Lua configuration
    lua << EOF
    ${luaRC.text}
    EOF

    set runtimepath^=${runtime}/etc
  '';

  neovim = pkgs.wrapNeovim vim.neovim.package {
    vimAlias = true;
    configure = {
      customRC = finalConfigRC;

      packages.myVimPackage = {
        start = builtins.filter (f: f != null) vim.startPlugins;
        opt = vim.optPlugins;
      };
    };
  };
}
