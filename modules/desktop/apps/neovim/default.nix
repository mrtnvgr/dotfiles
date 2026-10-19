{ lib, ... }: {
  options.modules.desktop.apps.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  imports = [
    ./plugins
    ./theme
  ];
}
