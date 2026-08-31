{ pkgs, user, ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./secrets/bitwig.nix

    ./uni.nix
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
