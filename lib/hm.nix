{ config, pkgs, lib ? pkgs.lib, ... }:

let
  cfg = config.programs.my-neovim;
  set = pkgs.neovimBuilder { config = cfg.settings; };
in
with lib; {
  options.programs.my-neovim = {
    enable = mkEnableOption "Personal Neovim";

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      example = literalExpression ''
        {
          vim = {
            customPlugins = with pkgs.vimPlugins; [
              vim-startuptime
            ];
            lsp = {
              enable = true;
              languages = {
                rust = false;
                nix = true;
                lua = false;
              }
            }
          };
        }
      '';
      description = "Attribute set of my-neovim preferences.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ set.neovim ];
  };
}
