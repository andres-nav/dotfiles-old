{pkgs}:
pkgs.stdenv.mkDerivation rec {
  pname = "wallpapers";
  version = "1.0";

  src = builtins.fetchGit {
    url = "https://github.com/andres-nav/wallpapers.git";
    rev = "c79a750430c4fd1b2e9219d4b76a2de284a344be";
  };

  builder = ./builder.sh;
}
