{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./basic
    ./ui
    ./coding
    ./colorscheme
    ./core
    ./editor
    ./lsp
    ./neovim
    ./treesitter
    ./util
    ./xcodebuild
  ];
}
