{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.media.latex;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.latex = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      buildPackages.texlive.combined.scheme-full
    ];
  };
}
