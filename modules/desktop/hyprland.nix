{ options, config, lib, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.hyprland;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.hyprland = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      MOZ_ENABLE_WAYLAND = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      # https://github.com/NixOS/nixpkgs/commit/ebde08adf37932ff59c27b5935840aa733965bdb
      GTK_USE_PORTAL = "1";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
