{ inputs, ... }: {
  nixpkgs.overlays = [
    inputs.mrtnvgr.outputs.overlays.default
  ];
}
