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
  cfg = config.modules.desktop.apps.ganttproject;
in
{
  options.modules.desktop.apps.ganttproject = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { user.packages = with pkgs; [ ganttproject-bin ]; };
}
