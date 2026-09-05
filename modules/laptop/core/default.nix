{ lib, ... }: {
  options.modules.laptop.enable = lib.mkEnableOption "Laptop mode";

  imports = [
    # TODO: think about using ondemand, but keeping sys76 scheduler and all other nice things
    ./powersafe.nix
  ];
}
