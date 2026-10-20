{ pkgs, lib ? pkgs.lib }:
let
  packageDirs = lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./.);

  packages = lib.fix (self:
    let
      callPackage = lib.callPackageWith (pkgs // self);
    in
    lib.mapAttrs (name: _: callPackage (./. + "/${name}/package.nix") { }) packageDirs);
in
packages
