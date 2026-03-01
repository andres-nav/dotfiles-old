# modules/hardware/laptop.nix --- support for laptops
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
  cfg = config.modules.hardware.laptop;
in
{
  options.modules.hardware.laptop = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.libinput = {
      enable = lib.mkDefault true; # trackpad
      touchpad.disableWhileTyping = true;
    };

    # Enable CPU overheating protection (only for Intel CPUs)
    services.thermald.enable = true;

    # Enable CPU frequency scaling and power management
    services.auto-cpufreq.enable = true;
    services.auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };

    services.fwupd.enable = true;

    powerManagement.powertop.enable = true;

    services.upower.enable = true;

    services.acpid.enable = true;

    hardware.enableRedistributableFirmware = lib.mkDefault true; # add firmware such has wifi

    environment.systemPackages = with pkgs; [
      acpi
      brightnessctl
      # TODO: hardware.acpilight.enable
    ];
  };
}
