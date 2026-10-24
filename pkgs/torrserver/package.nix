{
  lib,
  stdenv,
  fetchurl,
  pkgs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "torrserver";
  version = "147.1";

  src = fetchurl {
    url = "https://github.com/YouROK/TorrServer/releases/download/MatriX.${finalAttrs.version}/TorrServer-linux-amd64";
    hash = "sha256-KrpIj1fLJnSry/UwgBNiWltOCA87gFV/7GWw/kaukng=";
  };

  # The release asset is a statically linked Go binary.
  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/torrserver

    runHook postInstall
  '';

  passthru.updateScript = import ../update-scripts.nix { inherit pkgs; } {
    name = "torrserver";
    versionCommand = ''
      curl -fsSL https://api.github.com/repos/YouROK/TorrServer/releases/latest \
        | sed -nE 's/.*"tag_name": *"MatriX\.([0-9.]+)".*/\1/p' \
        | head -n1
    '';
  };

  meta = {
    description = "Torrent streaming server with an HTTP API and web UI";
    homepage = "https://github.com/YouROK/TorrServer";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "torrserver";
  };
})
