{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.terraria;
in {
  options.modules.services.terraria = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.terraria = {
      enable = true;
      openFirewall = true;
    };

    user.extraGroups = ["terraria"];
  };
}
