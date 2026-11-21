{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bitwig-theme-editor";
  version = "2.4.0";

  # The 2.4.0 release asset has a non-standard "-hotfix" suffix.
  src = fetchurl {
    url = "https://github.com/Berikai/bitwig-theme-editor/releases/download/${finalAttrs.version}/bitwig-theme-editor-${finalAttrs.version}-hotfix.jar";
    hash = "sha256-1MDZt2KtIRyTKNN+9jqZLWZamj0j5scydUjkvONaZnw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/bitwig-theme-editor/bitwig-theme-editor.jar

    # Default to the global theme file so the GUI and a patched Bitwig JAR
    # agree on ~/.config/bitwig-theme-editor/theme.bte.
    makeWrapper ${jre}/bin/java $out/bin/bitwig-theme-editor \
      --add-flags "-jar $out/share/bitwig-theme-editor/bitwig-theme-editor.jar --global-theme"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "bitwig-theme-editor";
      desktopName = "Bitwig Theme Editor";
      comment = "Theme editor for Bitwig Studio";
      icon = "preferences-desktop-theme";
      exec = "bitwig-theme-editor";
      categories = [
        "AudioVideo"
        "Audio"
      ];
    })
  ];

  meta = {
    description = "Cross-platform theme editor for Bitwig Studio";
    homepage = "https://github.com/Berikai/bitwig-theme-editor";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    platforms = lib.platforms.all;
    mainProgram = "bitwig-theme-editor";
  };
})
