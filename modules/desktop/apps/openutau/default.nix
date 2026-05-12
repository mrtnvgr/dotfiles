{ lib, config, pkgs, user, ... }: let
  cfg = config.modules.desktop.apps.openutau;

  singers = ".local/share/OpenUtau/Singers";

  sweet = pkgs.fetchzip {
    # Redist is not allowed yeah... But tasteloid.com is slow, sorry ;p
    url = "https://web.archive.org/web/20260512090457/https://00582533-ff9a-4f1d-ac6c-cdb11bd99c9d.filesusr.com/archives/36c86e_45b93ab74c3745498fc2f3a1a92e7cb0.zip?dn=Sweet_DS_v111.zip";
    hash = "sha256-+ntPaKXZMJT+u7q+quLVnBf88asnklkpZoERoZWsHr0=";
    stripRoot = false;
  };

  tiger = pkgs.fetchzip {
    url = "https://github.com/spicytigermeat/tiger_diffsinger/releases/download/v106/TIGER_DS_v106_PACK.zip";
    hash = "sha256-xIimAOuIvnyf5qqfKMbe3AKRcB4mi1DOx8XCmSrE4ZI=";
    stripRoot = false;
  };

  # momone

  # bitter
in {
  options.modules.desktop.apps.openutau.enable = lib.mkEnableOption "OpenUTAU";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.openutau ];

    home-manager.users.${user} = {
      home.file."${singers}/Sweet".source = sweet;
      home.file."${singers}/Tiger".source = tiger;
    };
  };
}
