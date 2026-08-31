{ lib, ... }: {
  imports = [
    ./renoise
    ./sunvox
  ];

  options._internals.isAnyDawInstalled = lib.mkEnableOption "<internal>";
}
