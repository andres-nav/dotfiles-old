{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
  emacs-nixos = ((pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages
    (epkgs: with epkgs; [ jinx ]));
in {
  options.modules.editors.emacs = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Doom Emacs dependencies
      binutils
      ripgrep
      gnutls
      findutils
      fd
      imagemagick
      zstd
      gnuplot # used to create graphs in org-mode

      # nodePackages.javascript-typescript-langserver
      # delta # used for diffing with magit-delta
      sqlite
      wordnet
      editorconfig-core-c

      # Language
      languagetool
      enchant
      libgccjit

      # for compiling treesit languages
      gcc

      # For org superagenda
      dash

      # Github Copilot
      nodejs

      # Org export LaTex
      buildPackages.texlive.combined.scheme-full
    ];

    services.emacs = {
      enable = true;
      package = emacs-nixos;
    };

    environment.shellAliases = {
      e = "emacsclient -nr";
      E = "emacsclient -nw";
    };

    home.configFile = {
      "doom" = {
        source = "${configDir}/doom";
        recursive = true;
        onChange = "${pkgs.writeShellScript "doom-change" ''
          #!/usr/bin/env sh
          DOOM="$XDG_CONFIG_HOME/emacs"

          if [ ! -f "$DOOM/bin/doom" ]; then
            rm -rf $DOOM # Remove old Emacs config
            git clone --depth 1 https://github.com/doomemacs/doomemacs $DOOM
            $DOOM/bin/doom -y install
          fi

          $DOOM/bin/doom reload
          emacsclient -e '(doom/reload)'
        ''}";
      };
    };
  };
}
