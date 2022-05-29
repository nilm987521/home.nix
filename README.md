## install nix package manager
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

## install home-manager
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install
```

## copy home.nix
```bash
mkdir -p ~/.config/nixpkgs
ln ./.NIX_PATH.sh ~/.NIX_PATH.sh
ln ./home.nix ~/.config/nixpkgs/
```

## home-manager switch
```bash
home-manager switch
```

## install oh-my-fish
```bash
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
fish install --path=~/.local/share/omf --config=~/.config/omf
rm install
omf install plain
```

## install nnn plugins
```bash
curl -Ls https://github.com/jarun/nnn/releases/download/v4.5/nnn-nerd-static-4.5.x86_64.tar.gz | tar xvf
sudo mv nnn-nerd-static /usr/bin
```

## install fish shell plugins manager 
```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

## install fzf key binds for fish
```bash
fisher install PatrickF1/fzf.fish
```

## install jdtls-launcher
```bash
sh ./jdtls-install.sh
fish_add_path  ~/.local/bin
```

