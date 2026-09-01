{ inputs, pkgs, user, ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./secrets/bitwig.nix

    ./uni.nix

    inputs.amnezia-vpn.nixosModules.default
    { programs.amnezia-vpn.enable = true; }
  ];

  modules.desktop = {
    boot.silent = true;

    dev.enable = true;

    daws.bitwig.enable = true;

    audio = {
      rt.enable = true;

      plugins.native.enable = true;
      plugins.wine.enable = true;

      daws.bitwig.enable = true;
    };
  };

  services.getty.greetingLine = builtins.readFile ./castle;

}
