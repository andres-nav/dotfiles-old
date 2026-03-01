# dotfiles

NixOS configuration managed with Flakes and Home Manager.

## Architecture

- **Flakes-based** — reproducible system configurations
- **Modular design** — composable host and feature modules
- **Home Manager** — declarative user environment management

## Structure

| Directory | Purpose |
|-----------|---------|
| `hosts/` | Machine-specific configurations (apolo, hades, poseidon, zeus) |
| `modules/` | Feature modules (desktop, dev, editors, hardware, services, shell, themes) |
| `config/` | Application dotfiles (doom, fish, i3, tmux, alacritty, etc.) |
| `packages/` | Custom Nix packages (globaleaks, wallpapers, yucade-website) |
| `bin/` | Utility scripts (rofi menus, bspwm helpers, screen capture) |
| `lib/` | Helper functions for Nix expressions |
| `templates/` | Scaffolding for new hosts and modules |

## Hosts

Four machines named after Greek gods:
- **apolo** — desktop configuration
- **hades** — desktop configuration
- **poseidon** — desktop configuration
- **zeus** — desktop configuration

## Modules

**Desktop:** i3, hyprland, apps, browsers, media, terminal emulators, VMs

**Development:** C/C++, Clojure, Common Lisp, Lua, Nix, Node.js, Python, R, Rust, Scala, Shell, Solidity

**Editors:** Emacs (Doom), Neovim, VSCodium

**Hardware:** Audio, Bluetooth, Ergodox, filesystems, laptop, NVIDIA, WiFi

**Services:** Docker, Nginx, Wireguard, Vaultwarden, Jellyfin, Syncthing, SSH, Gitea, Calibre, Transmission, and more

**Shell:** Fish, Zsh, Tmux, Git, Direnv, Starship, GnuPG, Cachix

**Themes:** Alucard theme configuration

## Usage

```bash
# Clone repository
git clone git@github.com:andres-nav/dotfiles-old.git /etc/dotfiles

# Build and switch (replace 'hostname' with your host)
sudo nixos-rebuild switch --flake /etc/dotfiles#hostname
```

## License

MIT © 2023 Andres Navarro