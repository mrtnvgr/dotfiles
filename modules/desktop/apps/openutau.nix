{ lib, config, pkgs, user, ... }: let
  cfg = config.modules.desktop.apps.openutau;

  tgmHifigan = pkgs.fetchzip {
    url = "https://github.com/mrtigermeat/tgm_hifigan/releases/download/v110/tgm_hifigan.oudep";
    extension = "zip";
    stripRoot = false;
    hash = "sha256-Y9SVOVJuDuJIeu05w2zPLzA2zLqz2csPmogSixkRKvc=";
  };
in {
  options.modules.desktop.apps.openutau = {
    enable = lib.mkEnableOption "OpenUTAU";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.openutau-latest ];

    home-manager.users.${user} = { lib, ... }: {
      home.activation.openutauSingers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        utaus="$HOME/UTAUs"
        singers="$HOME/.local/share/OpenUtau/Singers"

        $DRY_RUN_CMD mkdir -p "$utaus"

        if [ ! -L "$singers" ]; then
          $DRY_RUN_CMD mkdir -p "$(dirname "$singers")"
          $DRY_RUN_CMD ln -s "$utaus" "$singers"
        fi
      '';

      home.file.".local/share/OpenUtau/Dependencies/tgm_hifigan".source = tgmHifigan;
    };
  };
}
