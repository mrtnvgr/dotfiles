{ pkgs, user, ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./secrets/reaper.nix
  ];

  modules.desktop = {
    boot.silent = true;

    dev.enable = true;

    dev.platformio.enable = true;

    audio = {
      rt.enable = true;

      plugins.native.enable = true;
      plugins.wine.enable = true;

      daws.reaper.enable = true;

      daws.renoise.enable = true;
      # Remove this line to use a demo version.
      daws.renoise.releasePath = /home/${user}/.local/share/rns351.tar.gz;
    };
  };

  services.getty.greetingLine = builtins.readFile ./castle;

}
