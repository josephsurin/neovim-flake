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
    ./keys
    ./lsp
    ./neovim
    ./treesitter
    ./util
    ./xcodebuild
  ];
}
