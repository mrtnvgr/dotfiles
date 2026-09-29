{ pkgs, lib, config, user, ... }: let
  u-heLicenseSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption { type = lib.types.singleLineStr; };
      key = lib.mkOption { type = lib.types.singleLineStr; };
    };
  };

  u-heSubmodule = lib.types.submodule {
    options = {
      package = lib.mkOption { type = lib.types.package; };

      license = lib.mkOption {
        type = lib.types.nullOr u-heLicenseSubmodule;
        default = null;
      };
    };
  };

  cfg = config.modules.desktop.audio.plugins.native;

  mkUheLicensePath = name: ".u-he/${name}/Support/com.u-he.${name}.user.txt";
  mkUheLicense = license: pkgs.writeText "u-he-license" "${license.name}\n${license.key}";

  u-heLicensed = lib.filterAttrs (_: v: lib.isAttrs v.license) cfg.u-he;
in {
  options.modules.desktop.audio.plugins.native = {
    u-he = lib.mkOption {
      type = lib.types.attrsOf u-heSubmodule;
      default = {};
    };
  };

  config = lib.mkIf (cfg.enable && cfg.u-he != {}) {
    environment.systemPackages = lib.mapAttrsToList (_: v: v.package) cfg.u-he;

    home-manager.users.${user} = {
      home.file = lib.mapAttrs'
        (n: v: lib.nameValuePair (mkUheLicensePath n) { source = mkUheLicense v.license; })
      u-heLicensed;
    };
  };
}
