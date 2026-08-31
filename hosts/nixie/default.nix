{ pkgs, user, ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./uni.nix
  ];

  modules.desktop = {
    boot.silent = true;

    dev.enable = true;

    dev.platformio.enable = true;

    audio = {
      rt.enable = true;

      plugins.native.enable = true;
      plugins.wine.enable = true;

      daws.bitwig.enable = true;
    };
  };

  services.getty.greetingLine = builtins.readFile ./castle;

}
