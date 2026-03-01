{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.ergodox;
in {
  options.modules.hardware.ergodox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.wally-cli];

    hardware.keyboard.zsa.enable = true;

    user.extraGroups = ["plugdev"];

    services.xserver.xkbOptions = "compose:ralt";
  };
}
