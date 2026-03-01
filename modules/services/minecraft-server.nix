{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.minecraft-server;
in {
  options.modules.services.minecraft-server = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jdk17_headless
    ];

    networking.firewall.allowedTCPPorts = [25565];

    systemd.user.services.minecraft = {
      wantedBy = ["default.target"];
      after = ["network.target"];
      description = "Start MC Server";
      serviceConfig = {
        ExecStart = ''
          ${pkgs.jdk17_headless}/bin/java -Xmx7G -Xms1G @libraries/net/minecraftforge/forge/1.18.2-40.2.0/unix_args.txt nogui
        '';
        Restart = "on-failure";
        RestartSec = 5;
        WorkingDirectory = "/home/god/mc";
      };
    };
  };
}
