{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.flash.enable = true;

    keymaps = let
      mkJump = key: {
        inherit key;
        mode = [ "n" "x" "o" ];
        action.__raw = ''require("flash").jump'';
      };
    in [
      (mkJump "f")
      (mkJump "s")
    ];
  };
}
