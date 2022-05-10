{ config, pkgs, ... }:

{
  home.username = "nilm";
  home.homeDirectory = "/Users/nilm";
  home.stateVersion = "22.05";
  home.packages = [
    pkgs.htop
    pkgs.bat
    pkgs.fzf
    pkgs.direnv
    pkgs.python38
    pkgs.gcc
    pkgs.neovim
  ];

  programs.home-manager.enable = true;

# fish
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
     if test -e <nix_file_path_file>
         fenv source <nix_file_path_file>
     end
 '';
};


}
