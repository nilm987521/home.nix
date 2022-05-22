# install nix package maager
sh <(curl -L https://nixos.org/nix/install) --daemon
# install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install
# copy home.nix
mkdir -p ~/.config/nixpkgs
ln ~/Downloads/cli_env/home.nix ~/.config/nixpkgs/
ln ./.NIX_PATH.sh ~/.NIX_PATH.sh
ln ./.gitconfig ~/.gitconfig
# home-manager switch
home-manager switch
# install oh-my-fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
fish install --path=~/.local/share/omf --config=~/.config/omf
rm install
omf install plain
# install nnn plugins
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
# install fish shell plugins manager 
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
# install fzf key binds for fish
fisher install PatrickF1/fzf.fish


# install jdtls-launcher
sh ./jdtls-install.sh
fish_add_path  ~/.local/bin

