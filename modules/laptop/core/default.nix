{ config, lib, ... }: {
  options.modules.laptop.enable = lib.mkEnableOption "Laptop mode";

  config = lib.mkIf config.modules.laptop.enable {
    modules.desktop.enable = true;
  };

  imports = [
    # TODO: think about using ondemand, but keeping sys76 scheduler and all other nice things
    ./powersafe.nix
    ./kanshi.nix # monitor manager
  ];
}
