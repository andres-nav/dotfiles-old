# modules/desktop/media/lf.nix
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.media.ranger;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.ranger = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ranger
    ];

    home.configFile = {
      "ranger" = {
        source = "${configDir}/ranger";
        recursive = true;
      };
    };
  };
}
