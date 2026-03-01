{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.gnupg;
in {
  options.modules.shell.gnupg = with types; {
    enable = mkBoolOpt false;
    ssh = mkBoolOpt true;
    cacheTTL = mkOpt int 168000;
  };

  config = mkIf cfg.enable {
    environment.variables.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";

    programs.gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = cfg.ssh;
      };
      package = pkgs.gnupg24;
    };

    # HACK Without this config file you get "No pinentry program" on 20.03.
    #      programs.gnupg.agent.pinentryFlavor doesn't appear to work, and this
    #      is cleaner than overriding the systemd unit.
    home.configFile."gnupg/gpg-agent.conf" = {
      text = ''
        default-cache-ttl ${toString cfg.cacheTTL}
        default-cache-ttl-ssh ${toString cfg.cacheTTL}
        max-cache-ttl ${toString cfg.cacheTTL}
        max-cache-ttl-ssh ${toString cfg.cacheTTL}
        pinentry-program ${pkgs.pinentry.gnome3}/bin/pinentry
        allow-preset-passphrase
      '';
    };
  };
}
