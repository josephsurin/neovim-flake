{ config
, lib
, pkgs
, ...
}:
with lib; {
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
      persistence
      hex-nvim
    ];

    vim.luaConfigRC = /* lua */ ''
      -- ---------------------------------------
      -- Util Config
      -- ---------------------------------------
      require('persistence').setup({
        options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" }
      })
      map("n","<leader>qs",function() require("persistence").load() end, {desc = "Restore Session"})
      map("n","<leader>ql",function() require("persistence").load({ last = true }) end, {desc = "Restore Last Session"})
      map("n","<leader>qd",function() require("persistence").stop() end, {desc = "Don't save current session"})
    '';
  };
}
