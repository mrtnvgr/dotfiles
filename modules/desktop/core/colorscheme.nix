{ inputs, lib, ... }: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    (lib.mkAliasOptionModule ["modules" "desktop" "theme" "colorscheme"] ["colorScheme"])
  ];
}
