{ config, pkgs, ... }:

{
  home.username = "nilm";
  home.homeDirectory = "/Users/nilm";
  home.stateVersion = "22.05";
  home.packages = [
    pkgs.btop
    pkgs.tmux
    pkgs.bat
    pkgs.fzf
    pkgs.direnv
    pkgs.python38
    pkgs.gcc
    pkgs.neovim
    pkgs.cmatrix
    pkgs.exa
    pkgs.fishPlugins.fzf-fish
    #pkgs.nnn
    # sha256sum, md5sum
    pkgs.coreutils
    pkgs.fd
    # colorful man
    pkgs.tldr
    pkgs.figlet
  ];

  #=============
  # home-manager
  #=============
  programs.home-manager.enable = true;

  #===========
  # Fish
  #===========
  programs.fish = {
    enable = true;

    plugins = [{
      name="foreign-env";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "plugin-foreign-env";
        rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
        sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
      };
    }];

    shellInit =
      ''
      # nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      # home-manager
      if test -e ~/.NIX_PATH.sh
         fenv source ~/.NIX_PATH.sh
      end

      # nnn
      set -x NNN_PLUG 'f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'
      set -x NNN_BMS  'd:$HOME/Documents;D:$HOME/Downloads;h:$HOME'
      set -x BLK '0B'
      set -x CHR '0B'
      set -x DIR '04'
      set -x EXE '06'
      set -x REG '00'
      set -x HARDLINK '06'     
      set -x SYMLINK '06'
      set -x MISSING '00'     
      set -x ORPHAN '09'
      set -x FIFO '06'
      set -x SOCK '0B'     
      set -x OTHER '06'
      #set -x NNN_FCOLORS '$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER'
      set -x NNN_FCOLORS 'c1e2272e006033f7c6d6abc4'
      set -x EDITOR 'nvim'
      set -x VISUAL 'nvim'
      set fzf_preview_dir_cmd exa --all --color=always
      set fzf_preview_file_cmd bat
      set fzf_fd_opts --hidden --exclude=.git

      # alias
      alias flsof4="lsof -Pn -i4 | awk '{printf \"%10s %6s %5s %4s %-20s\n\", \$1, \$2, \$3, \$8, \$9}' | fzf --border --cycle --ansi --header-lines=1"
      alias fp="cat /etc/services | fzf"
      alias gcob='git checkout $(git branch | fzf --cycle --border --ansi)'
      alias vim='nvim'
      alias ls='exa'
      alias mans='tldr'
      '';
  };

  #====
  # Git
  #====
  programs.git = {
    enable = true;
    userName  = "Daniel Lan";
    userEmail = "nilm987521@gmail.com";
  };
}
