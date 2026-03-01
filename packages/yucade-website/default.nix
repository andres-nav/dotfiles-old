{
  lib,
  fetchFromGitHub,
  mkYarnPackage,
  fetchYarnDeps,
}:
mkYarnPackage rec {
  pname = "yucade-website";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "andres-nav";
    repo = "yucade-website";
    rev = "v${version}";
    hash = "sha256-ktlBIvwQSfsPUw4ar8P4el9uGp5Un34ZxKsPx/wCyuw=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-Oz8YTz+7TxXGBpESbF+12vg3MHJP16rcJOvxw4NadPY=";
  };

  buildPhase = ''
    runHook preBuild

    export HOME=deps/${pname}
    cd $HOME
    yarn --offline run build
    cp -r deps/${pname} $out

    runHook postbuild
  '';

  doDist = "true";

  meta = with lib; {
    description = "";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [andresnav];
  };
}
