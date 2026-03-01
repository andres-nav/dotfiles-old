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
  cfg = config.modules.desktop;
  configDir = config.dotfiles.configDir;
in
{
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message = "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion =
          let
            srv = config.services;
          in
          srv.xserver.enable
          || srv.sway.enable
          || !(anyAttrs (n: v: isAttrs v && anyAttrs (n: v: isAttrs v && v.enable)) cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    environment.systemPackages = with pkgs; [
      feh # image viewer
      dunst # notification manger
      htop
      libqalculate # calculator cli w/ currency conversion
      (makeDesktopItem {
        name = "scratch-calc";
        desktopName = "Calculator";
        icon = "calc";
        exec = ''scratch "${tmux}/bin/tmux new-session -s calc -n calc qalc"'';
        categories = [ "Development" ];
      })
      qgnomeplatform # QPlatformTheme for a better Qt application inclusion in GNOME
      libsForQt5.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra theme

      # Dictionary
      hunspellDicts.en_US-large
      hunspellDicts.es_ES
      # TODO: add custom dictionary `http://app.aspell.net/create?defaults=en_US-large`
    ];

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "CascadiaCode"
            "CascadiaMono"
            "Tinos"
            "SourceCodePro"
          ];
        })
      ];
    };

    ## Apps/Services
    services.xserver.displayManager.lightdm.greeters.mini = {
      user = config.user.name;
      # must add color module
      # extraConfig = ''
      #   text-color = "${cfg.colors.magenta}"
      #   password-background-color = "${cfg.colors.black}"
      #   window-color = "${cfg.colors.types.border}"
      #   border-color = "${cfg.colors.types.border}"
      # '';
    };

    # Set global dpi to 100
    services.xserver.dpi = 100;

    services.unclutter = {
      enable = true;
    };

    # Try really hard to get QT to respect my GTK theme.
    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    #env.QT_QPA_PLATFORMTHEME = "gnome";
    env.QT_STYLE_OVERRIDE = "kvantum";

    services.xserver.displayManager.sessionCommands = ''
      # GTK2_RC_FILES must be available to the display manager.
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    '';

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
      rm -rf .compose-cache .nv .pki .dbus .fehbg
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
