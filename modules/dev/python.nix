# modules/dev/python.nix --- https://godotengine.org/
#
# Python's ecosystem repulses me. The list of environment "managers" exhausts
# me. The Py2->3 transition make trainwrecks jealous. But SciPy, NumPy, iPython
# and Jupyter can have my babies. Every single one.
{
  config,
  options,
  lib,
  pkgs,
  my,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.python;
in {
  options.modules.dev.python = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        python311
        python311Packages.pip
        python311Packages.black
        python311Packages.pylint
        python311Packages.poetry-core
        python311Packages.ipykernel
      ];
    })

    (mkIf cfg.xdg.enable {
      })
  ];
}
