{
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:

let
  pname = "openutau-latest";
  version = "0.1.576";

  src = fetchurl {
    url = "https://github.com/openutau/OpenUtau/releases/download/${version}/OpenUtau-linux-x64.AppImage";
    hash = "sha256-Yxq6soO30AP6QyxFFWWAM6EXYHSAztz9vrVvxcprwxk=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/openutau/OpenUtau/${version}/OpenUtau/Assets/OpenUtau.png";
    hash = "sha256-J/bs/msQt/JTmT20wjqojHTatcoCbq0y/mmZld+9NQs=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "OpenUtau (latest)";
    comment = "Open source singing synthesis platform and UTAU successor";
    genericName = "Utau";
    startupWMClass = "OpenUtau";
    icon = pname;
    exec = pname;
    categories = [
      "AudioVideo"
      "Audio"
      "Midi"
    ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # The self-contained .NET 10 build needs ICU from the host; the FHS profile
  # appimageTools ships does not include it.
  extraPkgs = pkgs: [ pkgs.icu ];

  extraInstallCommands = ''
    install -Dm644 ${icon} $out/share/icons/hicolor/512x512/apps/${pname}.png
    install -Dm644 ${desktopItem}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
  '';

  meta = {
    description = "Upstream OpenUtau (official release build)";
    homepage = "https://github.com/openutau/OpenUtau";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
