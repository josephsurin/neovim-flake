{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim;
in {
  options.vim = {
    startConfigRC = mkOption {
      description = "start of vimrc contents";
      type = types.lines;
      default = "";
    };

    finalConfigRC = mkOption {
      description = "built vimrc contents";
      type = types.lines;
      internal = true;
      default = "";
    };

    configRC = mkOption {
      description = "vimrc contents";
      type = types.lines;
      default = "";
    };

    startLuaConfigRC = mkOption {
      description = "start of vim lua config";
      type = types.lines;
      default = "";
    };

    luaConfigRC = mkOption {
      description = "vim lua config";
      type = types.lines;
      default = "";
    };

    startPlugins = mkOption {
      description = "List of plugins to startup";
      default = [];
      type = with types; listOf (nullOr package);
    };

    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      default = [];
      type = with types; listOf package;
    };
  };

  config = {
    vim.finalConfigRC = ''
      " Basic configuration
      ${cfg.startConfigRC}

      " Config RC
      ${cfg.configRC}
    '';
  };
}
