{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  git,
  autoPatchelfHook,
  libx11,
  libxext,
  libxcursor,
  libxrandr,
  libGL,
  dbus,
  pkgs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sq8l";
  version = "1.0.0-beta.3";

  src = fetchFromGitHub {
    owner = "sq8l-revival";
    repo = "SQ8L";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-T014Cckhtt+cF79f3gxy0dM7FIIKFvTq3Gxmhg786L4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    # CMake applies the project's DPF/pugl patches with `git apply`.
    git
    autoPatchelfHook
  ];

  buildInputs = [
    libx11
    libxext
    libxcursor
    libxrandr
    libGL
    dbus
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/{vst,vst3,clap,lv2} $out/share/doc/sq8l
    cp -r bin/SQ8L.so $out/lib/vst/
    cp -r bin/SQ8L.vst3 $out/lib/vst3/
    cp -r bin/SQ8L.clap $out/lib/clap/
    cp -r bin/SQ8L.lv2 $out/lib/lv2/

    cp ${finalAttrs.src}/README.md ${finalAttrs.src}/THIRD_PARTY_NOTICES.md ${finalAttrs.src}/LICENSE.md $out/share/doc/sq8l/

    runHook postInstall
  '';

  # Every upstream release so far is a beta tag (plus a rolling "nightly" tag),
  # and nix-update skips prereleases by default, so pin the newest v* tag
  # explicitly instead of relying on its version detection.
  #
  # If this update script errors because the newest tag is no longer a beta,
  # upstream has started making stable releases: replace it with a plain
  # nix-update-script.
  passthru.updateScript = [
    (lib.getExe (pkgs.writeShellApplication {
      name = "update-sq8l";
      runtimeInputs = [
        pkgs.gnused
        pkgs.gitMinimal
        pkgs.nix-update
      ];
      text = ''
        repo=https://github.com/sq8l-revival/SQ8L.git

        version="$(git ls-remote --tags --refs --sort=-v:refname "$repo" 'refs/tags/v*' \
          | sed -n '1s|.*refs/tags/v||p')"

        if [ -z "$version" ]; then
          echo "update-sq8l: could not find any v* tag in $repo" >&2
          exit 1
        fi

        case "$version" in
          *beta*)
            ;;
          *)
            echo "update-sq8l: the newest tag is v$version, which is not a beta." >&2
            echo "update-sq8l: replace this updateScript with a plain nix-update-script." >&2
            exit 1
            ;;
        esac

        exec nix-update --flake --version="$version" "''${UPDATE_NIX_ATTR_PATH:-sq8l}"
      '';
    }))
  ];

  meta = {
    description = "Faithful 64-bit port of SQ8L, the Ensoniq SQ-80 emulation by Siegfried Kullmann";
    homepage = "https://github.com/sq8l-revival/SQ8L";
    # The port's own code is MIT, but the original's artwork, factory sounds and
    # SQ-80 data are reproduced without a licence grant (see LICENSE.md).
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
