{ Config, pkgs, ... }:

{
  home.username = "dlan";
  home.homeDirectory = "/home/dlan";
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    conda
    jdk11
    maven
    nerdfonts
    cacert
    ruby_3_0
    lvm2
    cargo
    trash-cli
    delta
    bc
    go
    universal-ctags
    wget
    # -- lsp 套件
    rnix-lsp
    # -- htop的炫砲版
    btop
    # -- shell視窗管理
    tmux
    # -- 比cat 畫面更好
    bat
    # -- 模糊查詢
    fd
    fzf
    fishPlugins.fzf-fish
    # -- 可以針對資料夾變更開發環境
    direnv
    nix-direnv
    # -- C語言編譯器
    clang
    cmake
    # -- 駭客任務
    cmatrix
    # -- ls的炫砲版
    exa
    # -- man的炫砲版
    tldr
    # -- 顯示Hello World!!
    figlet
  ];

  #=============
  # home-manager
  #=============
  programs.home-manager.enable = true;

  #=====
  # Fish
  #=====
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];

    shellInit = ''
      # vi-mode
      fish_vi_key_bindings
      set fzf_fd_opts --hidden --exclude=.git
      set fzf_preview_dir_cmd exa --all --color=always
      set fzf_preview_file_cmd bat
      # nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end
      # home-manager in fish config
      if test -e ~/.NIX_PATH.sh
         fenv source ~/.NIX_PATH.sh
      end
      # nnn in fish config
      set -x NNN_PLUG 'f:finder;o:fzopen;P:mocq;d:diffs;t:nmount;v:imgview'
      set -x NNN_BMS  'd:$HOME/Documents;D:$HOME/Downloads;h:$HOME'
      set -x NNN_FCOLORS 'c1e2272e006033f7c6d6abc4'
      set fzf_preview_dir_cmd exa --all --color=always
      set fzf_preview_file_cmd bat
      set fzf_fd_opts --hidden --exclude=.git
      # alias
      alias flsof4="lsof -Pn -i4 | awk '{printf \"%10s %6s %5s %4s %-20s\n\", \$1, \$2, \$3, \$8, \$9}' | fzf --border --cycle --ansi --header-lines=1"
      alias fp="cat /etc/services | fzf"
      alias gcob='git checkout $(git branch | fzf --cycle --border --ansi)'
      alias vim='nvim'
      alias vi='nvim'
      alias view='nvim -RM'
      alias ls='exa --icons --color=always --group-directories-first'
      alias ll='exa -alF --icons --color=always --group-directories-first'
      alias la='exa -a --icons --color=always --group-directories-first'
      alias l='exa -F --icons --color=always --group-directories-first'
      alias l.='exa -a | egrep "^\."'
      alias mans='tldr'
      alias nix-sha256='nix-prefetch-url --unpack'
      alias rm='trash'
      # 啟動direnv
      direnv hook fish | source
      # 安裝非free的套件所需要的
      set -x NIXPKGS_ALLOW_UNFREE 1
      # imput method
      set -x XMODIFIERS @im=ibus
      set -x QT_IM_MODULE @im=ibus
      set -x GTK_IM_MODULE @im=ibus
    '';
  };

  #=======
  # NeoVim
  #=======
  programs.neovim = {
    enable = true;
    #vimrc的設定
    extraConfig = ''
      set statusline=[%f]%m%r%h\ [%{getcwd()}]\ [%{&ff},%{&fenc}%{(&bomb?\",BOM\":\"\")}]%=[code=%b,\\u%04B]\ [col:%c,pos:%v]\ [line:%l/%L,%p%%]
      let g:vem_tabline_show = 2
      let g:vem_tabline_show_number = "index"
      " -- 自動開啟縮排顏色
      let g:indent_guides_enable_on_vim_startup = 1
      " -- ctags
      set tags=./tags
      let mapleader = "\\" 
      " -- 檔案參照功能
      filetype on
      filetype plugin on
      filetype indent on
      syntax on
      " -- 設定tab鍵寬度
      set tabstop=2
      set shiftwidth=2
      set expandtab
      let g:context_nvim_no_redraw = 1
      " -- 可以用滑鼠
      set mouse=a
      " -- 顯示行號
      set number
      set relativenumber
      set termguicolors
      " -- 設定檔案編碼方式
      set encoding=utf8
      setglobal fileencoding=utf-8
      " -- 開啟狀態欄
      set laststatus=2
      " -- float termianl設定
      let g:floaterm_keymap_toggle = '<F12>'
      let g:floaterm_width = 0.9
      let g:floaterm_height = 0.9
      " -- fzf 設定
      let g:fzf_preview_window = 'right:50%'
      let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }
      " -- 自動回到上次編輯位置
      au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
      " -- 安裝外掛
      call plug#begin()
        Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
        Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
        Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
        Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
        Plug 'petertriho/nvim-scrollbar'
        Plug 'kevinhwang91/nvim-hlslens'
        Plug 'williamboman/nvim-lsp-installer'
        Plug 'ap/vim-buftabline'
        Plug 'pacha/vem-tabline'
        Plug 'Yggdroot/indentLine'
        Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
        Plug 'jiangmiao/auto-pairs'
        Plug 'kyazdani42/nvim-web-devicons'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        Plug 'tpope/vim-dadbod'
        Plug 'kristijanhusak/vim-dadbod-ui'
        Plug 'kristijanhusak/vim-dadbod-completion'
        Plug 'mfussenegger/nvim-dap'
        Plug 'voldikss/vim-floaterm'
        Plug 'tpope/vim-fugitive'
        Plug 'karb94/neoscroll.nvim'
        Plug 'lilydjwg/colorizer'
        Plug 'neovim/nvim-lspconfig'
        Plug 'tmhedberg/SimpylFold'
        Plug 'tyru/caw.vim'
        Plug 'mattn/emmet-vim'
        Plug 'mbbill/undotree'
        Plug 'ryanoasis/vim-devicons'
        Plug 'LnL7/vim-nix'
        Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
        Plug 'posva/vim-vue'
      call plug#end()
      lua << EOF
        -- COQ.VIM 設定: 自動啟動+tabnine啟動
        vim.g.coq_settings = {auto_start = true, clients = {tabnine = {enabled = true}}}
        -- 啟用LSP
        local coq = require "coq"
        local saga = require 'lspsaga'
        saga.init_lsp_saga()
        require("nvim-lsp-installer").setup {
          automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
          ui = {
              icons = {
                  server_installed = "✓",
                  server_pending = "➜",
                  server_uninstalled = "✗"
              }
          }
        }
        require'lspconfig'.rnix.setup{coq.lsp_ensure_capabilities{}}
        require'lspconfig'.eslint.setup{coq.lsp_ensure_capabilities{}}
        require'lspconfig'.pyright.setup{coq.lsp_ensure_capabilities{}}
        require'lspconfig'.vimls.setup{coq.lsp_ensure_capabilities{}}
        require'lspconfig'.volar.setup{coq.lsp_ensure_capabilities{}}
        -- 設定ScrollerBar
        require('neoscroll').setup()
        local colors = require("tokyonight.colors").setup()
        require("scrollbar").setup({
            handle = {
                color = colors.bg_highlight,
            },
            marks = {
                Search = { color = colors.orange },
                Error = { color = colors.error },
                Warn = { color = colors.warning },
                Info = { color = colors.info },
                Hint = { color = colors.hint },
                Misc = { color = colors.purple },
            }
        })
        require("scrollbar.handlers").register("my_marks", function(bufnr)
          return {
              { line = 0 },
              { line = 1, text = "x", type = "Warn" },
              { line = 2, type = "Error" }
          }
        end)
        local kopts = {noremap = true, silent = true}
        vim.api.nvim_set_keymap('n', 'n',[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],kopts)
        vim.api.nvim_set_keymap('n', 'N',[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],kopts)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        require'lspconfig'.html.setup {
          capabilities = capabilities,
        }
  
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        require'lspconfig'.cssls.setup {
          capabilities = capabilities,
        }
        require("coq_3p") {
          { src = "nvimlua", short_name = "nLUA" },
          { src = "vimtex", short_name = "vTEX" },
          { src = "copilot", short_name = "COP", accept_key = "<c-f>" },
          { src = "bc", short_name = "MATH", precision = 6 },
          { src = "figlet", short_name = "BIG", trigger = "!big"},
          { src = "dap" }
        }
        vim.opt.termguicolors = true
      EOF
        
      " -- 設定主題
      colorscheme tokyonight
      " -- 最下面的快捷鍵設定，會覆蓋掉上面的
      nmap fp <Cmd>Files ./<CR>
      nmap fh <Cmd>Files ~<CR>
      "  -- ctrl+/設定為開啟、關閉註釋
      " 注意！Unix作業系統中的ctrl+/會被認為是ctrl+_，所以下面有這樣一條if判斷
      if has('win32')
          nmap <C-/> gcc
          vmap <C-/> gcc
      else
          nmap <C-_> gcc
          vmap <C-_> gcc
      endif
      " -- 設定smooth換頁
      nmap <PageUp> <C-u>
      nmap <PageDown> <C-d>
      
      " -- Ctrl + s 儲存
      nmap <silent><C-s> :w<CR>
      nmap <silent><C-c> :bdelete!<CR>
      " -- F5打開側邊資料夾
      nmap <silent><F5> :CHADopen <CR>
      " -- tab & Buffer切換
      nmap <leader>h <Plug>vem_move_buffer_left-
      nmap <leader>l <Plug>vem_move_buffer_right-
      nmap <leader>p <Plug>vem_prev_buffer-
      nmap <leader>n <Plug>vem_next_buffer-
      nnoremap <leader>1 :1tabnext<CR>
      nnoremap <leader>2 :2tabnext<CR>
      nnoremap <leader>3 :3tabnext<CR>
      nnoremap <leader>4 :4tabnext<CR>
      nnoremap <leader>5 :5tabnext<CR>
      nnoremap <leader>6 :6tabnext<CR>
      nnoremap <leader>7 :7tabnext<CR>
      nnoremap <leader>8 :8tabnext<CR>
      nnoremap <leader>9 :9tabnext<CR>
    '';
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
