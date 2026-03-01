# Apolo: Hostinger
# Command to remote build
# nixos-rebuild switch -j auto --use-remote-sudo --target-host root@212.227.144.87 --flake ~/git/dotfiles/#apolo
{
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix

    # (modulesPath + "/profiles/minimal.nix")
    # (modulesPath + "/profiles/headless.nix")
    # (modulesPath + "/profiles/hardened.nix") # TODO: check if it is really needed
    # (modulesPath + "/installer/scan/not-detected.nix") # TODO: check if it is really needed
  ];

  zramSwap.enable = true;
  boot.tmp.useTmpfs = false;

  ## Modules
  modules = {
    editors = {
      default = "neovim";
      nvim.enable = true;
    };
    shell = {
      git.enable = true;
      fish.enable = true;
    };
    services = {
      ssh.enable = true;
      zerotier = {
        enable = true;
        joinNetworks = ["1d71939404843223"];
      };

      globaleaks.enable = true;
    };
  };
}
