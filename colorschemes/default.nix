let
  mkColorscheme = p: let
    file = import p;

    termPalette = {
      regular0 = palette.background;
      regular1 = palette.red;
      regular2 = palette.green;
      regular3 = palette.yellow;
      regular4 = palette.blue;
      regular5 = palette.purple;
      regular6 = palette.teal;
      regular7 = palette.text;

      bright0 = palette.gray2;
      bright1 = palette.red;
      bright2 = palette.green;
      bright3 = palette.yellow;
      bright4 = palette.blue;
      bright5 = palette.purple;
      bright6 = palette.teal;
      bright7 = palette.text;
    };

    palette = termPalette // file.palette;
  in
    file // { inherit palette; };
in {
  catppuccin = mkColorscheme ./catppuccin.nix;
  gruvbox = mkColorscheme ./gruvbox.nix;
  solarized = mkColorscheme ./solarized.nix;
  # TODO: nord
  # TODO: everforest
}
