{ config, pkgs, ... }:

{
  home.username = "nilm";
  home.homeDirectory = "/home/nilm";
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    # rofi

    rnix-lsp
    go
    universal-ctags
    wget
    # -- node
    nodejs
    yarn
    yarn2nix
    # -- htop的炫砲版
    btop
    # -- shell視窗管理
    tmux
    # -- 比cat 畫面更好
    bat
    # -- 模糊查詢
    fd
    fzf
    # fishPlugins.fzf-fish
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
    # -- console的檔案管理，mac沒有辦法裝有icon的
    nnn
    # -- arm 不能用Conda 
    #conda
    # -- python
    python3
    # -- 1password，Mac最好是裝官方的
    #_1password
    #_1password-gui
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
      figlet Hello World!!
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
      alias ls='exa'
      alias mans='tldr'
      alias nix-sha25='nix-prefetch-url --unpack'
      # direnv
      direnv hook fish | source

      # 安裝非free的套件所需要的
      set -x NIXPKGS_ALLOW_UNFREE 1 
    '';
  };

  #=======
  # NeoVim
  #=======
  programs.neovim = {
    enable = true;
    #vimrc的設定
    extraConfig = ''
      set tabstop=2
      set shiftwidth=2
      set expandtab
      colorscheme tokyonight
      let g:context_nvim_no_redraw = 1
      set mouse=a
      set number
      set termguicolors
      " -- 設定檔案編碼方式
      set encoding=utf8
      setglobal fileencoding=utf-8
      set laststatus=2
      " -- termianl
      let g:floaterm_keymap_toggle = '<F12>'
      let g:floaterm_width = 0.9
      let g:floaterm_height = 0.9
      " -- fzf 設定
      " let g:fzf_preview_window = 'right:50%'
      " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }
      let g:airline#extensions#tabline#enabled=1
      " -- 當nerdtree為唯一視窗時，自動關閉
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

      " -- 是否顯示隱藏檔案
      let g:NERDTreeHidden=0
      " -- 讓nerdtree更漂亮
      let NERDTreeMinimalUI = 1
      let NERDTreeDirArrows = 1
      " -- nerdtree的git檔案狀設定
      let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
      " -- F5打開側邊資料夾
      "nnoremap <F5> :exec 'NERDTreeToggle' <CR>
      nmap <F5> :NERDTreeToggle <CR>
      " -- 快捷鍵e切換到前一個標籤
      nmap e <Plug>AirlineSelectPrevTab
      " -- 快捷鍵E切換到後一個標籤
      nmap E <Plug>AirlineSelectNextTab
      "  -- ctrl+/設定為開啟、關閉註釋
      " 注意！Unix作業系統中的ctrl+/會被認為是ctrl+_，所以下面有這樣一條if判斷
      if has('win32')
          nmap <C-/> gcc
          vmap <C-/> gcc
      else
          nmap <C-_> gcc
          vmap <C-_> gcc
      endif
      nmap <PageUp> <C-u>
      nmap <PageDown> <C-d>
      " -- Ctrl + s 儲存
      nmap <C-s> :w<CR>

      nnoremap <C-f> <Nop>
      vnoremap <C-f> <Nop>
      inoremap <C-f> <Nop>
      
      " -- 安裝外掛
      call plug#begin()
        Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
        Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
        Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
        Plug 'petertriho/nvim-scrollbar'
        Plug 'kevinhwang91/nvim-hlslens'
      call plug#end()



      lua << EOF
        require'lspconfig'.rnix.setup{}
        require('neoscroll').setup()
        local colors = require("tokyonight.colors").setup()
        local kopts = {noremap = true, silent = true}
        vim.api.nvim_set_keymap('n', 'n',[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],kopts)
        vim.api.nvim_set_keymap('n', 'N',[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],kopts)
        -- COQ.VIM 設定: 自動啟動+tabnine啟動
        vim.g.coq_settings = {auto_start = true, clients = {tabnine = {enabled = true}}}

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
        -- lsp key map
        local opts = { noremap=true, silent=true }
        local on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F2>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          -- 文件格式化 Document Formatting
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
        end
      EOF
    '';
    plugins = with pkgs.vimPlugins;
      # 不用nixpackage裡面的外掛，需要用let 定義
      let
        tokyonight = pkgs.vimUtils.buildVimPlugin {
          name = "tokyonight";
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "tokyonight.nvim";
            rev = "8223c970677e4d88c9b6b6d81bda23daf11062bb";
            sha256 = "1rzg0h0ab3jsfrimdawh8vlxa6y3j3rmk57zyapnmzpzllcswj0i";
          };
        };

        CoVim = pkgs.vimUtils.buildVimPlugin {
          name = "CoVim";
          src = pkgs.fetchFromGitHub {
            owner = "FredKSchott";
            repo = "CoVim";
            rev = "89afb870960f584dc07414bd08f12005dacbac23";
            sha256 = "1q76xlbh45q1s9bqwac08v2ahz72fanz5mc9gv45h92asjgl8yji";
          };
        };

      in
      [
        #CoVim
        vim-floaterm
        vim-fugitive
        vim-gitgutter
        neoscroll-nvim
        colorizer
        nvim-lspconfig
        SimpylFold
        context_filetype-vim
        caw-vim
        emmet-vim
        # nerdcommenter
        undotree
        nerdtree
        # nerdtree-git-plugin
        vim-snippets
        vim-devicons
        # 可以用nnn開啟檔案
        nnn-vim
        #
        editorconfig-vim
        # 狀態欄
        vim-airline
        # 讓nix檔有顏色
        vim-nix
        # 佈景主題
        tokyonight
        # lsp
      ]; # Only loaded if programs.neovim.extraConfig is set
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  #====
  # Git
  #====
  programs.git = {
    enable = true;
    userName = "Daniel Lan";
    userEmail = "nilm987521@gmail.com";
  };

}
