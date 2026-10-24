{ inputs, lib, ... }:
let
  inherit (inputs.nixpkgs) shortRev lastModifiedDate;

  # lastModifiedDate is YYYYMMDDHHMMSS
  snapshotDate = builtins.substring 0 8 lastModifiedDate;
in {
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;

  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.loader.timeout = lib.mkDefault 1;

  # This shows current NixOS release by default (e.g. 26.11).
  # Since we are on unstable, let's use nixpkgs revision and date.
  system.nixos.label = "${shortRev}-${snapshotDate}";
}
