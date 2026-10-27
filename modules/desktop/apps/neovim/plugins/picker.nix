{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.mini-pick = {
      enable = true;
    };

    # TODO: map "<leader>t" to todo_list? quickfix? (what is it?)
    keymaps = [
      { mode = "n"; key = "<leader>f"; action.__raw = ''MiniPick.builtin.files''; }
      { mode = "n"; key = "<leader>g"; action.__raw = ''MiniPick.builtin.grep_live''; }
      { mode = "n"; key = "<leader>r"; action.__raw = ''MiniPick.builtin.resume''; }
    ];

    plugins.web-devicons.enable = true;
    # TODO: use this instead `plugins.mini-icons.enable = true;`
  };
}
