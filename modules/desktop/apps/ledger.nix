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
  cfg = config.modules.desktop.apps.ledger;
in
{
  options.modules.desktop.apps.ledger = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # I think it is redundant and not needed
    # users.groups.plugdev = { };
    # user.extraGroups = [ "plugdev" ];

    hardware.ledger.enable = true;
  };
}
