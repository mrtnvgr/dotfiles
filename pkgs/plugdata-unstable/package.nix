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
