{ lib, config, pkgs, user, ... }: let
  cfg = config.modules.desktop.apps.openutau;

  sweet = pkgs.fetchzip {
    url = "https://web.archive.org/web/20260512090457/https://00582533-ff9a-4f1d-ac6c-cdb11bd99c9d.filesusr.com/archives/36c86e_45b93ab74c3745498fc2f3a1a92e7cb0.zip?dn=Sweet_DS_v111.zip";
    hash = "sha256-+ntPaKXZMJT+u7q+quLVnBf88asnklkpZoERoZWsHr0=";
    stripRoot = false;
  };

  tiger = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "tiger-voicebank";
    version = "106";

    src = pkgs.fetchzip {
      url = "https://github.com/spicytigermeat/tiger_diffsinger/releases/download/v${finalAttrs.version}/TIGER_DS_v${finalAttrs.version}_PACK.zip";
      hash = "sha256-j7mL27JsyAZWzTPrO/xhUIEjQEmsEMPw324xrjydzW0=";
    };

    nativeBuildInputs = [ pkgs.unzip ];

    installPhase = ''
      runHook preInstall
      unzip "Voice Library/TIGER_DS_v106.zip" -d $out
      runHook postInstall
    '';
  });

  # bitter
  bitter = pkgs.fetchzip {
    url = "https://web.archive.org/web/20260823134900if_/https://00582533-ff9a-4f1d-ac6c-cdb11bd99c9d.filesusr.com/archives/36c86e_c17531f3b5124eabb8e2644a30918c78.zip?dn=Bitter_DS_v111.zip";
    hash = "sha256-KYvJP1p3x8uD9fywMoge+DF7ERFiEiip3jaIBPqXZbQ=";
    stripRoot = false;
  };

  singers = ".local/share/OpenUtau/Singers";
  genVoice = name: x: src: lib.mkIf (cfg.enable && x) {
    home-manager.users.${user}.home.file."${singers}/${name}".source = src;
  };
in {
  options.modules.desktop.apps.openutau = {
    enable = lib.mkEnableOption "OpenUTAU";

    voices.sweet = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    voices.tiger = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    voices.bitter = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ pkgs.openutau ];
    })

    (genVoice "Sweet"  cfg.voices.sweet  sweet)
    (genVoice "Tiger"  cfg.voices.tiger  tiger)
    (genVoice "Bitter" cfg.voices.bitter bitter)
  ];
}
