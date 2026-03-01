{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.starship;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.starship = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
    };

    # system.userActivationScripts.cleanupZgen = ''
    #   rm -rf $ZSH_CACHE
    #   rm -fv $ZGEN_DIR/init.zsh{,.zwc}
    # '';
  };
}
