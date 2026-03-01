{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    #    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    loader = {
      systemd-boot.enable = false;
      grub.enable = true;
      grub.device = "/dev/vda";
    };
    initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_blk"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  swapDevices = [];

  networking.useDHCP = true;
  nixpkgs.hostPlatform = "x86_64-linux";

  virtualisation.hypervGuest.enable = true;

  # Storage
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };
}
