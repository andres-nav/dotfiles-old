{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    #    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelModules = [ "kvm-intel" ];

    # Refuse ICMP echo requests on my desktop/laptop; nobody has any business
    # pinging them, unlike my servers.
    kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;

    initrd.luks.devices."nixenc".device = "/dev/disk/by-partlabel/nixprimary";

    # For Kabi Lake Processor
    kernelParams = [
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
    ];
  };

  # Modules
  modules.hardware = {
    audio = {
      enable = true;
      muteOnSleep = true;
    };

    fs = {
      enable = true;
      ssd.enable = true;
    };

    nvidia.enable = true;

    laptop.enable = true;

    wifi.enable = true;

    bluetooth.enable = true;
  };

  # CPU
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.enableRedistributableFirmware = lib.mkDefault true; # for wifi

  # Storage
  fileSystems = {
    "/" = {
      device = "/dev/mapper/vg-root";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress-force=zstd"
      ];
    };

    "/home" = {
      device = "/dev/mapper/vg-root";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress-force=zstd"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/vg-root";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress-force=zstd"
        "noatime"
      ];
    };

    "/persist" = {
      device = "/dev/mapper/vg-root";
      fsType = "btrfs";
      options = [
        "subvol=persist"
        "compress-force=zstd"
      ];
    };

    "/var/log" = {
      device = "/dev/mapper/vg-root";
      fsType = "btrfs";
      options = [
        "subvol=log"
        "compress-force=zstd"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [ { device = "/dev/mapper/vg-swap"; } ];
}
