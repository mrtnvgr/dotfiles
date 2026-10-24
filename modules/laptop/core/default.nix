{ config, lib, ... }: {
  options.modules.laptop.enable = lib.mkEnableOption "Laptop mode";

  config = lib.mkIf config.modules.laptop.enable {
    modules.desktop.enable = true;
  };

  imports = [
    ./powersave.nix
    ./kanshi.nix # monitor manager
  ];
}
