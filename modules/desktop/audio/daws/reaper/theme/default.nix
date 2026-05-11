{ config, lib, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  imports = [
    ./colors.nix
  ];

  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix = {
      themes.reapertips = {
        enable = true;

        undimmed = true;
        colored_track_names = true;
      };

      config.theme.path = "<reapertips>";
    };

    # Dark menus
    # TODO: use a script that will generate this on theme switch
    #       add it to global startup scripts too
    home.file.".config/REAPER/libSwell-user.colortheme".source = ./libSwell-user.colortheme;
  };
}
