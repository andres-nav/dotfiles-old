# Hades: small server
{...}: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    editors = {
      default = "neovim";
      nvim.enable = true;
    };
    shell = {
      git.enable = true;
      tmux.enable = true;
      fish.enable = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
      zerotier = {
        enable = true;
        joinNetworks = ["1d71939404843223"];
      };
    };
  };

  services.logind.lidSwitch = "ignore";
}
