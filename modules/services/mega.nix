{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.services.mega;
in {
  options.modules.services.mega = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ megasync ];

    systemd.user.services.mega = {
      wantedBy = [ "default.target" ];
      after = [ "network.target" ];
      description = "Start MEGA";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.megasync}/bin/megasync";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
