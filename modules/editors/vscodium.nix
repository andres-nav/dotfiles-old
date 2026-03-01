{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.vscodium;
in {
  options.modules.editors.vscodium = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vscodium
    ];
  };
}
