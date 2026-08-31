{ lib, ... }: {
  imports = [
  ];

  options._internals.isAnyDawInstalled = lib.mkEnableOption "<internal>";
}
