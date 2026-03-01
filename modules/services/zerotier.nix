{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my;
let
  cfg = config.modules.services.zerotier;
in
{
  options.modules.services.zerotier = with types; {
    enable = mkBoolOpt false;
    joinNetworks = mkOpt (listOf str) [ ];
  };

  # TODO: investigate cloudflared
  # FIXME: make joinNetworks a secret
  config = mkIf cfg.enable {
    services.zerotierone = {
      enable = true;
      joinNetworks = cfg.joinNetworks;
    };
  };
}
