{ lib, ... }: {
  imports = [
    ./plugins
    ./rt.nix
  ];

  options.modules.desktop.paths.samples = lib.mkOption {
    type = with lib.types; nullOr singleLineStr;
    default = null;
  };
}
