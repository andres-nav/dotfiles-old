# modules/desktop/media/lf.nix
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.media.lf;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.media.lf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lf
      trash-cli
      fd
      fzf
      perl538Packages.FileMimeInfo # for mimeopen
    ];

    home.configFile = {
      "lf".source = "${configDir}/lf";
    };
  };
}
