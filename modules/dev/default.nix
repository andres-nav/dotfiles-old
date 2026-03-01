{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev;
in {
  options.modules.dev = {
    tools.enable = mkBoolOpt true;
    xdg.enable = mkBoolOpt true;
  };

  config = mkIf cfg.tools.enable {
    environment.systemPackages = with pkgs; [
      mob
            gnumake
    ];
  };
}
