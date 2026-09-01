{ config, lib, ... }: let
in {
  options.home.link = lib.mkOption {
    type = with lib.types; attrsOf singleLineStr;
    default = {};
  };

  config = {
    home.file = lib.mapAttrs' (target: source:
      let
        path = if lib.hasPrefix "/" source then source else "${config.home.homeDirectory}/${source}";
        src = config.lib.file.mkOutOfStoreSymlink path;
      in
        lib.nameValuePair target { source = src; }
    ) config.home.link;
  };
}
