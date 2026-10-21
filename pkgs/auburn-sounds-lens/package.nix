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
  name = "auburn-sounds-lens";
  version = "1.4";

  src = fetchzip {
    url = "https://www.auburnsounds.com/downloads/Lens-FREE-${finalAttrs.version}.zip";
    hash = "sha256-9iwW2bEvvo1f6cVhyws/2lqJdoohyP3frPbx1n7paYg=";
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
        cp -r "Linux-64b-${lib.toUpper format}-FREE/Auburn Sounds Lens.${format}" $out/lib/${format}
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
    name = "auburn-sounds-lens";
    versionCommand = ''
      curl -fsSL --user-agent 'Mozilla/5.0' https://www.auburnsounds.com/products/Lens.html \
        | sed -n 's/.*"softwareVersion": "\([0-9.]*\)".*/\1/p' \
        | head -n1
    '';
  };

  meta = {
    description = "Spectral dynamics processor with unbelievable punch and clarity";
    homepage = "https://www.auburnsounds.com/products/Lens.html";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
