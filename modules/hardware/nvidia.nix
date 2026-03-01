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
  cfg = config.modules.hardware.nvidia;
in
{
  options.modules.hardware.nvidia = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production; # install 535 as of 2024-02-14
      modesetting.enable = true; # required for some wayland compositors
      open = false; # (2024-02-14) only supported for version 2000 and older (currently experimental)
      prime = {
        offload.enable = false; # (2024-02-14) only supported for version 2000 and older (currently experimental)
        sync.enable = true;

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    hardware.graphics = {
      enable = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    environment.systemPackages = with pkgs; [
      # Respect XDG conventions, damn it!
      (writeScriptBin "nvidia-settings" ''
        #!${stdenv.shell}
        mkdir -p "$XDG_CONFIG_HOME/nvidia"
        exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
      '')

      # To use nvidia offload, use nvidia graphics card for program nvidia-offload blender
      (writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      '')
    ];
  };
}
