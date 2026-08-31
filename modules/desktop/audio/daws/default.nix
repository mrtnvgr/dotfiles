{ lib, ... }: {
  imports = [
    ./sunvox
  ];

  options._internals.isAnyDawInstalled = lib.mkEnableOption "<internal>";
}
