{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.plugins.native;

  theme = pkgs.writeText "plugdata-theme" ''
    <?xml version="1.0" encoding="UTF-8" ?>
    <Theme
      theme="OXIDEC"
      toolbar_background="ff{{ background | strip }}"
      toolbar_text="ff{{ text | strip }}"
      toolbar_active="ff{{ blue | strip }}"
      toolbar_hover="ff{{ gray | strip }}"
      tabbar_background="ff{{ void | strip }}"
      tab_text="ff{{ text | strip }}"
      selected_tab_background="ff{{ gray2 | strip }}"
      selected_tab_text="ff{{ text | strip }}"
      canvas_background="ff{{ background | strip }}"
      canvas_text="ff{{ text | strip }}"
      canvas_dots="ff{{ gray4 | strip }}"
      presentation_background="ff{{ gray2 | strip }}"
      default_object_background="ff{{ void | strip }}"
      object_outline_colour="ff{{ gray3 | strip }}"
      selected_object_outline_colour="ff{{ blue | strip }}"
      gui_internal_outline_colour="ff{{ gray3 | strip }}"
      toolbar_outline_colour="ff{{ background | strip }}"
      outline_colour="ff{{ gray3 | strip }}"
      data_colour="ff{{ blue | strip }}"
      connection_colour="ff{{ text | strip }}"
      signal_colour="ff{{ orange | strip }}"
      gem_colour="ff{{ green | strip }}"
      dialog_background="ff{{ void | strip }}"
      sidebar_colour="ff{{ void | strip }}"
      sidebar_text="ff{{ text | strip }}"
      sidebar_background_active="ff{{ gray | strip }}"
      levelmeter_active="ff{{ blue | strip }}"
      levelmeter_background="ff{{ gray2 | strip }}"
      levelmeter_thumb="ff{{ text | strip }}"
      panel_background="ff{{ background | strip }}"
      panel_foreground="ff{{ void | strip }}"
      panel_text="ff{{ text | strip }}"
      panel_background_active="ff{{ gray | strip }}"
      popup_background="ff{{ void | strip }}"
      popup_background_active="ff{{ gray | strip }}"
      popup_text="ff{{ text | strip }}"
      scrollbar_thumb="ff{{ gray4 | strip }}"
      graph_area="ff{{ red | strip }}"
      grid_colour="ff{{ blue | strip }}"
      caret_colour="ff{{ blue | strip }}"
      text_object_background="ff{{ background | strip }}"
      iolet_area_colour="ff{{ background | strip }}"
      iolet_outline_colour="ff{{ gray3 | strip }}"
      comment_text_colour="ff{{ text | strip }}"
    />
  '';
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.plugdata ];

    home-manager.users.${user} = {
      # TODO: make modules.desktop.paths.documents option
      # TODO: change config.xdg.userDirs.documents to it too
      oxidec.files.".local/documents/plugdata/oxidec.plugdatatheme".source = theme;
    };
  };
}
