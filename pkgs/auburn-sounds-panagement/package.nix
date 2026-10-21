{
  stdenvNoCC,
  lib,
  fetchzip,
  autoPatchelfHook,
  libX11,
  libgcc,
  pkgs,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "auburn-sounds-panagement";
  version = "2.8";

  src = fetchzip {
    url = "https://www.auburnsounds.com/downloads/Panagement-FREE-${finalAttrs.version}.zip";
    hash = "sha256-73BSUitxjUDJo6/zwrmuFuLMY0EcdX+0geEZKF+1SGU=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libX11
    libgcc
  ];

  installPhase =
    let
      mkInstaller = format: ''
        mkdir -p $out/lib/${format}
        cp -r "Linux-64b-${lib.toUpper format}-FREE/Auburn Sounds Panagement 2.${format}" $out/lib/${format}
      '';
      mkInstallers = formats: lib.concatStringsSep "\n" (map mkInstaller formats);
    in
    ''
      runHook preInstall

      pushd Linux
        ${mkInstallers [
          "clap"
          "lv2"
          "vst3"
        ]}
      popd

      runHook postInstall
    '';

  passthru.updateScript = import ../update-scripts.nix { inherit pkgs; } {
    name = "auburn-sounds-panagement";
    versionCommand = ''
      curl -fsSL --user-agent 'Mozilla/5.0' https://www.auburnsounds.com/products/Panagement.html \
        | sed -n 's/.*"softwareVersion": "\([0-9.]*\)".*/\1/p' \
        | head -n1
    '';
  };

  meta = {
    description = "Transdimensional Binaural Reverb Processor";
    homepage = "https://www.auburnsounds.com/products/Panagement.html";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
