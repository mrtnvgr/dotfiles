{
  stdenvNoCC,
  lib,
  fetchzip,
  autoPatchelfHook,
  libX11,
  libgcc,
  zlib,
  pkgs,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "auburn-sounds-couture";
  version = "1.10";

  src = fetchzip {
    url = "https://www.auburnsounds.com/downloads/Couture-FREE-${finalAttrs.version}.zip";
    hash = "sha256-tZKJVa9lJfPTm68/noQHs14Eq7l4DXCzBKZ62s/9sh4=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libX11
    libgcc
    zlib
  ];

  installPhase =
    let
      mkInstaller = format: ''
        mkdir -p $out/lib/${format}
        cp -r "Linux-64b-${lib.toUpper format}-FREE/Auburn Sounds Couture.${format}" $out/lib/${format}
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
    name = "auburn-sounds-couture";
    versionCommand = ''
      curl -fsSL --user-agent 'Mozilla/5.0' https://www.auburnsounds.com/products/Couture.html \
        | sed -n 's/.*"softwareVersion": "\([0-9.]*\)".*/\1/p' \
        | head -n1
    '';
  };

  meta = {
    description = "Level-independent Dynamics Processor";
    homepage = "https://www.auburnsounds.com/products/Couture.html";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
