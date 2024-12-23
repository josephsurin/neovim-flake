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

  treeSitterPlug = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

  buildPlug = name:
    buildVimPlugin {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
    };

  vimPlugins = {
    inherit treeSitterPlug;
  };
in {
  neovimPlugins = let
    xs = listToAttrs (map (n: nameValuePair n (buildPlug n)) plugins);
  in
    xs // vimPlugins;
}
