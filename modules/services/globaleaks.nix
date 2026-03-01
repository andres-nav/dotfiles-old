# modules/services/globaleaks.nix
#
# For keeping an eye on things...
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.globaleaks;
in {
  options.modules.services.globaleaks = with types; {
    enable = mkBoolOpt false;

    package = mkOption {
      type = types.package;
      description = lib.mdDoc ''
        Globaleaks package to use.
      '';
      default = pkgs.my.globaleaks;
    };

    workingPath = mkOption {
      type = path;
      description = "Path for the backend working directory.";
      default = "/var/lib/globaleaks";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open ports in the firewall for the web server.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [80 443];
    };

    systemd.services = {
      globaleaks = {
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        wants = ["network-online.target"];

        description = "Start GlobaLeaks service.";
        path = [cfg.package]; # add package to the PATH
        preStart = ''
          mkdir -p ${cfg.workingPath}
          chmod 700 ${cfg.workingPath}
          chown -R root:root ${cfg.workingPath}
        '';

        serviceConfig = {
          ExecStart = ''
            ${cfg.package}/bin/globaleaks --working-path=${cfg.workingPath}
          '';
          Type = "forking";
          PIDFile = "${cfg.workingPath}/globaleaks.pid";
          Restart = "always";
          RestartSec = 5;
        };
      };
    };
  };
}
