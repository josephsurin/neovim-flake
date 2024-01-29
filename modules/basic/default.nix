{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim;
in {
  options.vim = {
    customPlugins = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "List of additional plugins";
    };
  };

  config = {
    vim.startPlugins = [pkgs.neovimPlugins.toggleterm pkgs.neovimPlugins.plenary] ++ cfg.customPlugins;

    vim.startConfigRC = ''
      " ---------------------------------
      " Basic init.vim Settings
      " ---------------------------------
      let mapleader=" "
      set autowrite
      set clipboard=unnamedplus
      set completeopt=menu,menuone,noselect
      set conceallevel=0
      set confirm
      set cursorline
      set expandtab
      set formatoptions=jcroqlnt
      set grepformat=%f:%l:%c:%m
      set ignorecase
      set inccommand=nosplit
      set laststatus=0
      set list
      set mouse=a
      set number
      set pumblend=10
      set pumheight=10
      set scrolloff=4
      set shiftround
      set shiftwidth=4
      set noshowmode
      set sidescrolloff=8
      set signcolumn=yes
      set smartcase
      set autoindent
      set spelllang=en
      set splitbelow
      set splitright
      set tabstop=2
      set termguicolors
      set timeoutlen=300
      set undofile
      set undolevels=10000
      set updatetime=200
      set wildmode=longest:full,full
      set winminwidth=5
      set wrap
      inoremap jk <esc>
      nnoremap <C-j> <C-d>
      nnoremap <C-k> <C-u>
      vmap <C-c> "+yi
      vmap <C-x> "+c
      vmap <C-v> c<ESC>"+p
    '';

    vim.startLuaConfigRC = /* lua */ ''
        -- ---------------------------------
        -- Basic init.lua settings
        -- ---------------------------------
        vim.loader.enable()
        vim.opt.grepprg = "rg --vimgrep"
        vim.opt.shortmess:append { W = true, I = true, c = true }

        if vim.fn.has("nvim-0.9.0") == 1 then
          vim.opt.splitkeep = "screen"
          vim.opt.shortmess:append { C = true }
        end

        vim.g.markdown_recommended_style = 9

        -- ---------------------------------
        -- Basic keybindings
        -- ---------------------------------
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.silent = opts.silent ~= false
          vim.keymap.set(mode,lhs,rhs,opts)
        end

        -- better up/down
        map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
        map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

        -- Move to window using the <ctrl> hjkl keys
        map("n", "<C-h>", "<C-w>h", { desc = "Go to the left window" })
        map("n", "<C-l>", "<C-w>l", { desc = "Go to the right window" })

        -- Resize window using <ctrl> arrow keys
        map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
        map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
        map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
        map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

        -- Move lines
        map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
        map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
        map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
        map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
        map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
        map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

        -- buffers
        map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
        map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
        map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
        map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
        map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
        map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
        map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "Open a new unnamed buffer" })

        -- Clear search with <esc>
        map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

        -- Clear search, diff update and redraw
        -- taken from runtime/lua/_editor.lua
        map(
          "n",
          "<leader>ur",
          "<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
          { desc = "Redraw / clear hlsearch / diff update" }
        )

        map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

        -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
        map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
        map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
        map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
        map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
        map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
        map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

        -- Add undo break-points
        map("i", ",", ",<c-g>u")
        map("i", ".", ".<c-g>u")
        map("i", ";", ";<c-g>u")

        -- save file
        map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

        -- better indenting
        map("v", "<", "<gv")
        map("v", ">", ">gv")

        map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
        map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
        map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

        map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
        map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

        -- Toggle settings
        -- map("n", "<leader>uf", toggle(), { desc = "Toggle format on Save" })
        map("n", "<leader>us", function() vim.opt.spell = not(vim.opt.spell:get()) end, { desc = "Toggle Spelling" })
        map("n", "<leader>uw", function() vim.opt.wrap = not(vim.opt.wrap:get()) end, { desc = "Toggle Word Wrap" })
        map(
          "n",
          "<leader>ul",
          function()
            vim.opt.linenumber = not(vim.opt.linenumber:get())
            vim.opt.relativenumber = not(vim.opt.relativenumber:get())
          end,
          { desc = "Toggle Line Numbers" }
        )
        -- map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
        map(
          "n",
          "<leader>uc",
          function()
            if vim.o.conceallevel > 0 then local next = 0 else local next = 3 end
            vim.opt.conceallevel = next
          end,
          { desc = "Toggle Conceal" }
        )

        -- Toggleterm terminal setup
        local function mkTerminal(cmd,dir,hidden,w,h)
          local Terminal = require("toggleterm.terminal").Terminal
          local opts = {
            direction = "float",
            float_opts = {
              border = "curved"
            },
            on_open = function(term)
              vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap=true, silent=true})
            end
          }
          if not (cmd == nil) then opts.cmd = cmd end
          if not (dir == nil) then opts.dir = dir end
          if hidden then opts.hidden = true end
          if not (w == nil) then opts.float_opts.width = math.floor(w) end
          if not (w == nil) then opts.float_opts.height = math.floor(h) end
          local t = Terminal:new(opts)
          return t
        end
        local root_gitui = mkTerminal("${pkgs.gitui}/bin/gitui","git_dir",true,vim.o.columns * 0.9,vim.o.lines * 0.95)
        function _root_lg_toggle()
          root_gitui:toggle()
        end
        local cwd_gitui = mkTerminal("${pkgs.gitui}/bin/gitui",nil,true,vim.o.columns * 0.9,vim.o.lines * 0.95)
        function _cwd_lg_toggle()
          cwd_gitui:toggle()
        end
        local root_term = mkTerminal(nil,"git_dir",false,nil,nil)
        function _root_term_toggle()
          root_term:toggle()
        end
        local cwd_term = mkTerminal(nil,nil,false,nil,nil)
        function _cwd_term_toggle()
          cwd_term:toggle()
        end

        -- gitui in floating terminal
        map("n", "<leader>gg", "<cmd>lua _root_lg_toggle()<cr>", { desc = "gitui (root dir)" })
        map("n", "<leader>gG", "<cmd>lua _cwd_lg_toggle()<cr>", { desc = "gitui (cwd)" })

        -- Floating terminal
        map("n", "<leader>ft", "<cmd>lua _root_term_toggle()<cr>", { desc = "Terminal (root dir)" })
        map("n", "<leader>fT", "<cmd>lua _cwd_term_toggle()<cr>", { desc = "Terminal (cwd)" })
        map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter normal mode" })

        map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

        -- highlights under cursor
        if vim.fn.has("nvim-0.9.0") == 1 then
          map("n", "<leader>ui", vim.show_pos, { desc = "Inspect pos" })
        end

        -- windows
        map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
        map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
        map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
        map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
        map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
        map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

        -- tabs
        map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
        map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
        map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
        map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
        map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
        map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

        -- ---------------------------------
        -- Auto Commands
        -- ---------------------------------
        local function augroup(name)
          return vim.api.nvim_create_augroup("cwf_"..name, {clear = true})
        end

        -- Check if we need to reload the file when it changed
        vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
          group = augroup("checktime"),
          command = "checktime",
        })

        -- Highlight on yank
        vim.api.nvim_create_autocmd({"TextYankPost"}, {
          group = augroup("highlight_yank"),
          callback = function()
            vim.highlight.on_yank()
          end,
        })

        -- resize splits if window got resized
        vim.api.nvim_create_autocmd({"VimResized"}, {
          group = augroup("resize_splits"),
          callback = function()
            vim.cmd("tabdo wincmd =")
          end,
        })

        -- go to the last loc when opening a buffer
        vim.api.nvim_create_autocmd({"BufReadPost"}, {
          group = augroup("last_loc"),
          callback = function()
            local mark = vim.api.nvim_buf_get_mark(0,'"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end,
        })

        -- close some filetypes with <q>
        vim.api.nvim_create_autocmd({"FileType"}, {
          group = augroup("close_with_q"),
          pattern = {
            "PlenaryTestPopup",
            "help",
            "lspinfo",
            "man",
            "notify",
            "qf",
            "query", -- :InspectTree
            "spectre_panel",
            "startuptime",
            "tsplayground",
            "toggleterm",
            "checkhealth",
          },
          callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", {buffer=event.buf, silent=true})
          end,
        })

        -- wrap and check for spell in text filetypes
        vim.api.nvim_create_autocmd({"FileType"}, {
          group = augroup("wrap_spell"),
          pattern = {"gitcommit", "markdown"},
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
          end,
        })
      '';
  };
}
