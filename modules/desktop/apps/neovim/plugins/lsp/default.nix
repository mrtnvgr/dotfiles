{ lib, config, user, ... }: let
  desk = config.modules.desktop;
  enabled = desk.apps.neovim.enable && desk.dev.rust.enable;
in {
  home-manager.users.${user} = lib.mkIf enabled {
    programs.nixvim.plugins.lsp = {
      enable = true;

      keymaps.lspBuf = {
        K = "hover";
        gD = "references";
        gd = "definition";
        gi = "implementation";
        gt = "type_definition";
        "<F2>" = "rename";
        "<F4>" = "code_action";
      };

      keymaps.diagnostic.gl = "open_float";
    };
  };

  imports = [
    ./signs.nix

    ./servers/nix.nix
  ];
}
