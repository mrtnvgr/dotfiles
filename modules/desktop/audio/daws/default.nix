{ lib, ... }: {
  imports = [
    ./reaper
    ./renoise
    ./sunvox
  ];

  options._internals.isAnyDawInstalled = lib.mkEnableOption "<internal>";
}
