{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  cargo-tauri,
  rustPlatform,
  nodejs,
  yarnConfigHook,
  pkg-config,
  glib-networking,
  gst_all_1,
  openssl,
  webkitgtk_4_1,
  wrapGAppsHook4,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "splicedd";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "ascpixi";
    repo = "splicedd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gV0fQEprGzQcIXuuzXwNUQTYALtvxcb50hQzt99Ah1s=";
  };

  cargoHash = "sha256-IdsEXBU1XpiASceOJlhDjlGRe/R2CBkfKUExUFEMaqo=";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Sms6NYXO3pGeJRXC1jo40sqGmHLyemADgkuaj+NlEjA=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    yarnConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    openssl
    webkitgtk_4_1
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--flake" ];
  };

  meta = {
    description = "Custom frontend for the Splice sample library";
    homepage = "https://github.com/ascpixi/splicedd";
    license = lib.licenses.gpl3Only;
    mainProgram = "splicedd";
    platforms = lib.platforms.linux;
  };
})
