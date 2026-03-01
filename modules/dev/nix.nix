{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.nix;
in {
  options.modules.dev.nix = {enable = mkBoolOpt false;};

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [nil alejandra nixfmt-rfc-style];};
}
