{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.media.printing;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.media.printing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
    };

    # To detect printers
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    environment.systemPackages = with pkgs; [ cups ];

  };
}
