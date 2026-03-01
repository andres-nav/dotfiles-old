{ options, config, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.media.skype;
in {
  options.modules.desktop.media.skype = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    # Enable GNOME Keyring to store Skype credentials
    services.gnome.gnome-keyring = { enable = true; };

    environment.systemPackages = with pkgs; [ skypeforlinux ];
  };
}
