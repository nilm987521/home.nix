{ config, pkgs, ... }:

{
  home.username = "nilm";
  home.homeDirectory = "/home/nilm";
  home.stateVersion = "22.05";
  home.packages = [
    pkgs.tabnine
    pkgs.nixfmt
    pkgs.go
    pkgs.universal-ctags
    # nodejs
    pkgs.nodejs
    pkgs.yarn
    pkgs.yarn2nix
    # htop的炫砲版
    pkgs.btop
    pkgs.tmux
    # 比cat 畫面更好
    pkgs.bat
    # 模糊查詢
    pkgs.fd
    pkgs.fzf
    pkgs.fishPlugins.fzf-fish
    # 可以針對資料夾變更開發環境
    pkgs.direnv
    pkgs.nix-direnv
    # C語言編譯器
    pkgs.gcc
    # 駭客任務
    pkgs.cmatrix
    # ls的炫砲版
    pkgs.exa
    # man的炫砲版
    pkgs.tldr
    # 顯示Hello World!!
    pkgs.figlet
    # console的檔案管理，mac沒有辦法裝有icon的
    pkgs.nnn
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

    plugins = [{
      name = "foreign-env";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "plugin-foreign-env";
        rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
        sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
      };
    }];

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
      set encoding=utf8
      setglobal fileencoding=utf-8
      set laststatus=2
      let g:airline#extensions#tabline#enabled=1

      nnoremap <F5> :exec 'NERDTreeToggle' <CR>
      nnoremap <F6> :exec 'Neoformat' <CR>

      lua << EOF
        require'lspconfig'.pyright.setup{}
        vim.lsp.set_log_level("debug")
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

        neoformat = pkgs.vimUtils.buildVimPlugin {
          name = "neoformat";
          src = pkgs.fetchFromGitHub {
            owner = "sbdchd";
            repo = "neoformat";
            rev = "409ebbba9f4b568ea87ab4f2de90a645cf5d000a";
            sha256 = "13vfy252wv88rbw61ap1vg1x5br28d7rwbf19r28ajvg2xkvw816";
          };
        };

      in [
        tabnine-vim
        neoformat
        nerdtree
        nerdtree-git-plugin
        vim-snippets
        vim-devicons
        ncm2
        ncm2-bufword
        ncm2-path
        ncm2-tmux
        ncm2-ultisnips
        vim-autoformat
        # 
        coq-vim
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
        vim-lsp
        nvim-lspconfig
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
