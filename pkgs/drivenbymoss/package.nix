{
  lib,
  stdenvNoCC,
  fetchzip,
  pkgs,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "drivenbymoss";
  version = "26.6.5";

  src = fetchzip {
    url = "https://www.mossgrabers.de/Software/Bitwig/DrivenByMoss-${finalAttrs.version}-Bitwig.zip";
    hash = "sha256-DIFJBY9SX4QklKeSaazG/DJ+0psKKO+hfsO51+OQQC4=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 DrivenByMoss.bwextension $out
    runHook postInstall
  '';

  preferLocalBuild = true;

  passthru.updateScript = import ../update-scripts.nix { inherit pkgs; } {
    name = "drivenbymoss";
    versionCommand = ''
      curl -fsSL --user-agent 'Mozilla/5.0' https://www.mossgrabers.de/Software/Bitwig/ \
        | grep -oE 'DrivenByMoss-[0-9.]+-Bitwig\.zip' \
        | sed -E 's/^DrivenByMoss-//; s/-Bitwig\.zip$//' \
        | sort -V \
        | tail -n1
    '';
  };

  meta = {
    description = "Bitwig Studio extension for supported MIDI controllers";
    homepage = "https://www.mossgrabers.de/Software/Bitwig/Bitwig.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
  };
})
