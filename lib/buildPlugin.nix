{
  pkgs,
  inputs,
  plugins,
  lib ? pkgs.lib,
  ...
}: final: prev:
with lib;
with builtins; let
  inherit (prev.vimUtils) buildVimPlugin;

  buildPlug = name:
    buildVimPlugin {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
      doCheck = false;
    };

  vimPlugins = {
    treeSitterPlug = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
    telescope-fzf-native = pkgs.vimPlugins.telescope-fzf-native-nvim;
  };
in {
  neovimPlugins = let
    xs = listToAttrs (map (n: nameValuePair n (buildPlug n)) plugins);
  in
    xs // vimPlugins;
}
