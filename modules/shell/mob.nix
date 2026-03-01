{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.mob;
in {
  options.modules.shell.mob = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mob
    ];

    environment.variables = {
      MOB_WIP_BRANCH = "wip";
      MOB_WIP_COMMIT_MESSAGE = "wip next [ci-skip] [ci skip] [skip ci]";
      MOB_START_COMMIT_MESSAGE = "wip start [ci-skip] [ci skip] [skip ci]";
      MOB_WIP_BRANCH_PREFIX = "wip/";
    };
  };
}
