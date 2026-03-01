# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.nvim;
in {
  options.modules.editors.nvim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      neovim
    ];

    environment.shellAliases = {
      vim = "nvim";
      v = "nvim";
    };
  };
}
