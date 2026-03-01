{ config, lib, ... }:
with builtins;
with lib;
let
in
#blocklist = fetchurl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
{
  #networking.extraHosts = '' # TODO: populate extra hosts in each config (probably option in zerotier module)

  # Block garbage
  # ${optionalString config.services.xserver.enable (readFile blocklist)}
  #'';

  time.timeZone = mkDefault "Europe/Madrid";
  location = {
    latitude = 55.88;
    longitude = 12.5;
  };

  # Keyboard default
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console = {
    keyMap = mkDefault "us";
    useXkbConfig = mkDefault true;
  };

  services.xserver.xkb = {
    layout = mkDefault "us";
    options = mkDefault "caps:swapescape,ctrl:swap_lalt_lctl";
    # variant = mkDefault "dvorak";
  };

  security.sudo.wheelNeedsPassword = false;

  # Disable man pages (they are really slow compiling)
  documentation.man.enable = false;
  documentation.nixos.enable = false;
  documentation.dev.enable = false;
}
