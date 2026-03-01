{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.r;
in {
  options.modules.dev.r = {enable = mkBoolOpt false;};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; let
      R-with-my-packages = rWrapper.override {packages = with rPackages; [styler languageserver];};
    in [
      R-with-my-packages
    ];
  };
}
