{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.hardware.fs;
in {
  options.modules.hardware.fs = {
    enable = mkBoolOpt false;
    ssd.enable = mkBoolOpt false;
    # TODO automount.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.udevil.enable = true; # For automounting drives

    # Support for more filesystems, mostly to support external drives
    environment.systemPackages = with pkgs; [
      sshfs
      exfat # Windows drives
      ntfs3g # Windows drives
      hfsprogs # MacOS drives
    ];

    services = mkIf cfg.ssd.enable { fstrim.enable = true; };
  };
}
