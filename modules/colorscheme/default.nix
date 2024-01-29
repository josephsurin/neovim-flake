{
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [gruvbox-material nvim-transparent];

    vim.configRC = /* vim */ ''
      if has('termguicolors')
        set termguicolors
      endif
      set background=dark

      let g:gruvbox_material_background = 'hard'
      let g:gruvbox_material_foreground = 'mix'
      let g:gruvbox_material_ui_contrast = 'high'
      let g:gruvbox_material_transparent_background = 0

      function! s:gruvbox_material_custom() abort
        let l:palette = gruvbox_material#get_palette(g:gruvbox_material_background, g:gruvbox_material_foreground, {})
        call gruvbox_material#highlight('CmpPmenu', l:palette.fg0, l:palette.bg0)
        call gruvbox_material#highlight('CmpSel', l:palette.fg0, l:palette.blue)
        call gruvbox_material#highlight('PmenuSel', l:palette.green, l:palette.none)
        call gruvbox_material#highlight('CmpBorder', l:palette.bg5, l:palette.none)
        call gruvbox_material#highlight('CmpDoc', l:palette.fg0, l:palette.bg0)
        call gruvbox_material#highlight('CmpDocBorder', l:palette.bg5, l:palette.none)
        call gruvbox_material#highlight('NormalFloat', l:palette.fg0, l:palette.bg0)
        call gruvbox_material#highlight('FloatBorder', l:palette.bg5, l:palette.none)
        call gruvbox_material#highlight('BufferLineFill', l:palette.none, l:palette.bg_dim)
        call gruvbox_material#highlight('BufferLineSeparator', l:palette.none, l:palette.bg_dim)
        call gruvbox_material#highlight('NeoTreeNormal', l:palette.none, ["#151818", "230"])
        call gruvbox_material#highlight('NeoTreeEndOfBuffer', l:palette.none, ["#151818", "230"])
      endfunction

      augroup GruvboxMaterialCustom
        autocmd!
        autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
      augroup END

      colorscheme gruvbox-material
    '';

    vim.luaConfigRC = /* lua */ ''
      -- Enable transparency plugin
      require('transparent').setup()
      map("n", "<leader>ut", "<cmd>TransparentToggle<cr>", { desc = "Toggle Transparency" })
    '';
  };
}
