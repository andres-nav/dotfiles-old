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
  cfg = config.modules.shell.git;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git # TODO: make this general
      gitAndTools.git-annex
      gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.diff-so-fancy
      (mkIf config.modules.shell.gnupg.enable gitAndTools.git-crypt)
    ];

    home.configFile = {
      "git" = {
        source = "${configDir}/git";
        recursive = true;
      };
    };
  };
}
