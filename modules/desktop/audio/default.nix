{ lib, ... }: {
  imports = [
    ./plugins
    ./rt.nix
  ];

  options.modules.desktop.audio.samples = lib.mkOption {
    type = with lib.types; nullOr singleLineStr;
    default = null;
  };
}
