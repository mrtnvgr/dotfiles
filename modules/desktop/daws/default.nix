{ lib, ... }: {
  imports = [
    ./bitwig.nix
  ];

  options._internals.isAnyDawInstalled = lib.mkEnableOption "<internal>";
}
