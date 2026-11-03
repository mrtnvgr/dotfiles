{
  pkgs,
  ...
}:
# Track plugdata's develop branch, which is what upstream builds its
# "unstable"/nightly packages from. The base derivation is still taken from
# nixpkgs, so packaging fixes and runtime dependencies are inherited.
pkgs.plugdata.overrideAttrs (prev: {
  version = "unstable-2026-11-02";

  src = pkgs.fetchFromGitHub {
    owner = "plugdata-team";
    repo = "plugdata";
    rev = "29915444d6ad39b4cafec7a26067cd4837cbcd07";
    hash = "sha256-EXHxEA33fjQ2IM/B4QnyMaTXAQOP9ZFY0CBDnjW2L/0=";
    fetchSubmodules = true;
  };

  # The nixpkgs package backports a gcc-15 fix for the vendored Pure Data.
  # plugdata's develop branch already carries it, so the patch no longer applies.
  patches = [ ];

  # plugdata loads fonts/documentation from a packed resource file next to the
  # loaded module. VST3/LV2 bundles already contain it, but the standalone
  # executable and the CLAP plugins do not, which makes plugdata abort at
  # startup (and makes Bitwig's plugin host crash when it loads the CLAP).
  postInstall = (prev.postInstall or "") + ''
    resource=$(find Plugins -name plugdata-resources.bin | head -n 1)
    install -Dm644 "$resource" $out/bin/plugdata-resources.bin
    install -Dm644 "$resource" $out/lib/clap/plugdata-resources.bin
  '';

  passthru = (prev.passthru or { }) // {
    updateScript = pkgs.nix-update-script {
      extraArgs = [
        "--flake"
        "--version=branch=develop"
      ];
    };
  };

  meta = prev.meta // {
    description = "Plugin wrapper around Pure Data to allow patching in a wide selection of DAWs (development snapshot)";
  };
})
