{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,

  # Libraries loaded by the bundled Qt runtime and audio backends.
  alsa-lib,
  atk,
  cairo,
  dbus,
  file,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  krb5,
  libdrm,
  libgbm,
  libglvnd,
  libjack2,
  libpulseaudio,
  lz4,
  libx11,
  libxcb,
  libxcb-cursor,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-util,
  libxcb-wm,
  libxkbcommon,
  pango,
  pipewire,
  sqlite,
  wayland,
  zlib,
  zstd,

  pkgs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "diffscope";
  version = "0.2.0-nightly.20261029.1";

  # Upstream publishes only nightly releases. The release tag uses dots and
  # hyphens, while the asset name replaces them with underscores.
  releaseTag = "v${finalAttrs.version}";
  assetVersion = lib.replaceStrings [ "." "-" ] [ "_" "_" ] finalAttrs.version;

  src = fetchurl {
    url = "https://github.com/diffscope/diffscope-project/releases/download/${finalAttrs.releaseTag}/DiffScope_nightly_${finalAttrs.assetVersion}_Linux_amd64_portable.tar.xz";
    hash = "sha256-SmyGZqV3/TyKELWP/GJLauNXQyumEIh0xsCXyIzaXck=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
    atk
    cairo
    dbus
    file
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    krb5
    libdrm
    libgbm
    libglvnd
    libjack2
    libpulseaudio
    lz4
    libx11
    libxcb
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-util
    libxcb-wm
    libxkbcommon
    pango
    pipewire
    sqlite
    wayland
    zlib
    zstd
  ];

  # The release archive is a self-contained portable tree. Qt and most other
  # libraries are bundled, so only the remaining system libraries are patched
  # in. The wrapper must live outside the payload: DiffScope resolves its Qt
  # plugins, QML modules and translations relative to the real executable
  # path, which is why the wrapper execs the binary in place.
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -a . $out/opt/diffscope
    chmod -R u+w $out/opt/diffscope

    # Desktop files, icons and MIME data must be visible at the usual prefix.
    ln -s opt/diffscope/share $out/share

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/diffscope/bin/DiffScope $out/bin/DiffScope \
      "''${gappsWrapperArgs[@]}" \
      --set QT_PLUGIN_PATH "$out/opt/diffscope/lib/Qt/plugins" \
      --set QML_IMPORT_PATH "$out/opt/diffscope/qml" \
      --set QML2_IMPORT_PATH "$out/opt/diffscope/qml"
  '';

  passthru.updateScript = import ../update-scripts.nix { inherit pkgs; } {
    name = "diffscope";
    versionCommand = ''
      curl -fsSL 'https://api.github.com/repos/diffscope/diffscope-project/releases?per_page=1' \
        | sed -nE 's/.*"tag_name": *"v([^"]+)".*/\1/p' \
        | head -n1
    '';
  };

  meta = {
    description = "Singing voice synthesis editor powered by DiffSinger";
    longDescription = ''
      DiffScope is a singing voice synthesis editor built around the DiffSinger
      engine. This package repackages the upstream Linux nightly build, which
      includes the Qt runtime, synthesis backend and all bundled plugins.
    '';
    homepage = "https://diffscope.org/";
    downloadPage = "https://github.com/diffscope/diffscope-project/releases";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "DiffScope";
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
