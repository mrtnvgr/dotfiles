# WARN: completely vibecoded derivation
# The client is finicky to make it work on NixOS...
# I hope that upstream package will be fixed eventually
# to replace this mess of patching and bin packaging

{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  p7zip,
  python3,
  wrapGAppsHook3,

  # Runtime libraries that the bundled Qt 6.10 runtime expects from the system.
  glib,
  dbus,
  fontconfig,
  freetype,
  libglvnd,
  libdrm,
  libgbm,
  zlib,
  zstd,
  brotli,
  harfbuzz,
  libkrb5,
  libxkbcommon,
  gtk3,
  gdk-pixbuf,
  pango,
  cairo,
  atk,
  libx11,
  libxcb,
  libxcb-util,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  libxcb-cursor,

  # Runtime helpers placed on the wrapper PATH.
  iproute2,
  iptables,
  procps,
  gawk,
  coreutils,

  pkgs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amnezia-vpn";
  version = "5.0.1.5";

  src = fetchurl {
    url = "https://github.com/amnezia-vpn/amnezia-client/releases/download/${finalAttrs.version}/AmneziaVPN_${finalAttrs.version}_linux_x64.run";
    hash = "sha256-3bRx774UkjKqmMdVNPmNQhFLFf3Hl2gC+P6uujILx5E=";
  };

  offsetScanner = ./find-7z-offsets.py;

  # The .run file is a Qt Installer Framework binary: an ELF launcher with six
  # 7z archives appended (bin, lib, plugins, qml, translations and the desktop
  # integration files). Slice each one out instead of executing the installer.
  unpackPhase = ''
    runHook preUnpack

    mkdir -p AmneziaVPN
    offsets=$(python3 "$offsetScanner" "$src")
    echo "candidate 7z archives at offsets: $offsets"

    for off in $offsets; do
      tail -c +$((off + 1)) "$src" > slice.7z
      # Every archive is followed by the next one, so 7z warns about trailing
      # data and exits non-zero while still extracting correctly. False-positive
      # signature hits simply fail to open and are skipped.
      7z x -y -bso0 -bsp0 -oAmneziaVPN slice.7z >/dev/null 2>&1 || true
      rm -f slice.7z
    done

    for entry in bin lib plugins qml translations AmneziaVPN.desktop AmneziaVPN.service AmneziaVPN.png; do
      if [ ! -e AmneziaVPN/$entry ]; then
        echo "error: '$entry' is missing after extraction - the installer layout changed" >&2
        exit 1
      fi
    done

    sourceRoot=AmneziaVPN
    runHook postUnpack
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    p7zip
    python3
    wrapGAppsHook3
  ];

  # The installer ships a complete, self-contained Qt 6.10 runtime in `lib/`
  # together with a `bin/qt.conf` that points Qt at the bundled `plugins/` and
  # `qml/` trees. nixpkgs' wrapQtAppsHook would export QT_PLUGIN_PATH and
  # QML2_IMPORT_PATH for a *different* Qt build, loading ABI-incompatible
  # plugins into the vendored runtime, so the binaries are wrapped by hand and
  # the bundled Qt is left to resolve itself through qt.conf.
  dontWrapQtApps = true;
  dontWrapGApps = true;

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    glib
    dbus
    fontconfig
    freetype
    libglvnd
    libdrm
    libgbm
    zlib
    zstd
    brotli
    harfbuzz
    libkrb5
    libxkbcommon
    gtk3
    gdk-pixbuf
    pango
    cairo
    atk
    libx11
    libxcb
    libxcb-util
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    libxcb-cursor
  ];

  # patchelf rewrites a binary's RUNPATH by shifting ELF sections around, and Go
  # binaries do not survive that: ld.so segfaults inside dl_main before main()
  # ever runs, so the daemon just sees "Tunnel process encountered an error:
  # QProcess::Crashed". amneziawg-go needs nothing but libc, which the
  # interpreter finds through its own default path, so it only gets its
  # interpreter repointed and is kept away from autoPatchelfHook entirely.
  dontAutoPatchelf = true;

  postFixup = ''
    autoPatchelf -- \
      $out/share/amnezia-vpn/lib \
      $out/share/amnezia-vpn/plugins \
      $out/share/amnezia-vpn/qml \
      $out/share/amnezia-vpn/bin/AmneziaVPN \
      $out/share/amnezia-vpn/bin/AmneziaVPN-service \
      $out/share/amnezia-vpn/bin/openvpn

    patchelf --set-interpreter "$(cat "$NIX_CC/nix-support/dynamic-linker")" \
      $out/share/amnezia-vpn/bin/amneziawg-go

    # tun2socks is a statically linked Go binary and needs no patching at all.
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/amnezia-vpn
    cp -a bin lib plugins qml translations $out/share/amnezia-vpn/
    chmod -R u+w $out/share/amnezia-vpn
    patchShebangs $out/share/amnezia-vpn/bin/update-resolv-conf.sh

    # The GUI and the daemon locate openvpn, geoip.dat, geosite.dat and
    # update-resolv-conf.sh relative to QCoreApplication::applicationDirPath(),
    # which resolves through /proc/self/exe - so the wrappers must live outside
    # the payload tree and exec the real binaries in place.
    mkdir -p $out/bin
    for prog in AmneziaVPN AmneziaVPN-service; do
      makeWrapper $out/share/amnezia-vpn/bin/$prog $out/bin/$prog \
        "''${gappsWrapperArgs[@]}" \
        --prefix PATH : "${
          lib.makeBinPath [
            iproute2
            iptables
            procps
            gawk
            coreutils
          ]
        }:$out/share/amnezia-vpn/bin" \
        --prefix XDG_DATA_DIRS : "$out/share"
    done

    install -Dm444 AmneziaVPN.png $out/share/icons/hicolor/512x512/apps/AmneziaVPN.png

    install -Dm444 AmneziaVPN.desktop $out/share/applications/AmneziaVPN.desktop
    substituteInPlace $out/share/applications/AmneziaVPN.desktop \
      --replace-fail '/usr/share/pixmaps/AmneziaVPN.png' 'AmneziaVPN'

    install -Dm444 AmneziaVPN.service $out/lib/systemd/system/AmneziaVPN.service
    substituteInPlace $out/lib/systemd/system/AmneziaVPN.service \
      --replace-fail '/opt/AmneziaVPN/bin/AmneziaVPN-service' "$out/bin/AmneziaVPN-service"

    runHook postInstall
  '';

  passthru.updateScript = import ../update-scripts.nix { inherit pkgs; } {
    name = "amnezia-vpn";
    versionCommand = ''
      curl -fsSL https://api.github.com/repos/amnezia-vpn/amnezia-client/releases/latest \
        | sed -nE 's/.*"tag_name": *"([0-9.]+)".*/\1/p' \
        | head -n1
    '';
  };

  meta = {
    description = "Amnezia VPN client, repackaged from the official Linux installer";
    longDescription = ''
      AmneziaVPN is a client for self-hosted VPN servers supporting AmneziaWG,
      WireGuard, OpenVPN, Xray/VLESS, ShadowSocks and other protocols.

      This package extracts the prebuilt binaries from the official Qt Installer
      Framework `.run` release rather than building from source, so it tracks
      upstream releases immediately at the cost of being binary-only.
    '';
    homepage = "https://github.com/amnezia-vpn/amnezia-client";
    downloadPage = "https://amnezia.org/en/downloads";
    license = lib.licenses.gpl3Only;
    mainProgram = "AmneziaVPN";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
