# Zeus: my main laptop
{ ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      i3.enable = true;
      apps = {
        ledger.enable = true;
      };
      browsers = {
        default = "firefox";
        brave.enable = true;
        firefox.enable = true;
      };
      media = {
        discord.enable = true;
        documents.enable = true;
        latex.enable = true;
        spotify.enable = true;
        skype.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      vm = {
        # qemu.enable = true;
        # virtualbox.enable = true;
      };
    };
    dev = {
      tools.enable = true;
      # node.enable = true;
      python.enable = true;
      # solidity.enable = true;
      # cc.enable = true;
      # nix.enable = true;
      # r.enable = true;
    };
    editors = {
      default = "emacsclient -nr";
      emacs.enable = true;
      nvim.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      starship.enable = true;
      # nom.enable = true;
      tmux.enable = true;
      fish.enable = true;
      mob.enable = true;
    };
    services = {
      mega.enable = true;
      docker.enable = true;
      zerotier = {
        enable = true;
        joinNetworks = [
          "9bee8941b5092092"
          "60ee7c034acb3fe5"
        ];
      };
    };

    theme.active = "alucard";
  };

  ## Local config

  # programs.ssh.startAgent = true;
  # services.openssh.startWhenNeeded = true;

  # nix.gc.automatic = true;
}
