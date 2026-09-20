{ inputs, config, pkgs, lib, user, ... }: let
  cfg = config.modules.desktop.audio.plugins.wine;

  types = lib.types;

  mkListOption = type: lib.mkOption {
    inherit type;
    default = [];
  };

  home = config.home-manager.users.${user}.home.homeDirectory;

  pluginsDir = "Program Files/Common Files/VST3";

  bottleModule = {
    options = {
      tricks = mkListOption (types.listOf types.str);
      plugins = mkListOption (types.listOf types.path);

      data = mkListOption (types.listOf (types.submodule ({ config, ... }: {
        options = {
          src = lib.mkOption { type = types.path; };

          dest = lib.mkOption {
            type = types.str;
            default = baseNameOf (toString config.src);
            defaultText = lib.literalExpression "baseNameOf src";
          };

          method = lib.mkOption {
            type = types.enum [ "symlink" "copy" ];
            default = "symlink";
          };

          clean = lib.mkOption {
            type = types.bool;
            default = true;
          };
        };
      })));

      regFiles = mkListOption (types.listOf types.path);

      hosts = mkListOption (types.listOf types.str);

      postScript = lib.mkOption {
        type = types.lines;
        default = "";
      };
    };
  };

  mkDataScript = data: lib.concatMapStringsSep "\n" (x: let
    clean = lib.optionalString x.clean ''rm -rf "$DSTPATH"'';

    copy = {
      symlink = ''ln -s "${x.src}" "$DSTPATH"'';
      copy = ''cp -r "${x.src}" "$DSTPATH"'';
      # copyContents = ''mkdir -p "$DSTPATH"; cp -rs "${x.src}"/. "$DSTPATH"/'';
    }.${x.method};

    # `find` does not follow symlinks, so this is only meaningful for real copies.
    chmod = lib.optionalString (x.method != "symlink") ''
      # https://superuser.com/a/91938
      find "$DSTPATH" -type d -exec chmod 755 {} +
      find "$DSTPATH" -type f -exec chmod 644 {} +
    '';
  in /* bash */ ''
    DSTPATH="$WINEPREFIX/drive_c/${x.dest}"
    mkdir -pv "$(dirname "$DSTPATH")"
    ${clean}
    ${copy}
    ${chmod}
  '') data;

  # TODO: use actual symlinking after https://github.com/robbert-vdh/yabridge/issues/454 is resolved
  mkPluginScript = plugins: lib.concatLines ([
    ''rm -rf "$WINEPREFIX/drive_c/${pluginsDir}"''
    ''mkdir -p "$WINEPREFIX/drive_c/${pluginsDir}"''
  ] ++ map (plugin: ''
    cp -r "${plugin}" "$WINEPREFIX/drive_c/${pluginsDir}"
  '') plugins);

  mkRegScript = regFiles:
    lib.concatMapStringsSep "\n" (x: ''wine regedit "${x}"'') regFiles;

  mkEnv = name: bottle: let
    envName = "audio-plugins_${name}";

    env = pkgs.mkWineEnv {
      name = envName;
      wine = cfg.package;

      inherit (bottle) tricks;

      postScript = lib.concatLines [
        (mkDataScript bottle.data)
        (mkRegScript bottle.regFiles)
        (mkPluginScript bottle.plugins)
        bottle.postScript
      ];
    };
  in {
    inherit env;
    prefix = "${home}/.wine-nix/${envName}";
    command = "${env}/bin/${envName}";
  };

  bottles = lib.mapAttrs mkEnv cfg.bottles;

  activation = pkgs.writeShellApplication {
    name = "wine-audio-plugins-activate";
    runtimeInputs = [ pkgs.yabridgectl ];
    text = lib.concatLines (
      lib.mapAttrsToList (_: bottle: bottle.command) bottles
      ++ [ "yabridgectl sync -p -n" ]
    );
  };
in {
  options.modules.desktop.audio.plugins.wine = {
    enable = lib.mkEnableOption "Windows audio plugins through WINE";

    package = lib.mkOption {
      type = types.package;
      default = pkgs.wineWow64Packages.yabridge;
    };

    bottles = lib.mkOption {
      type = types.attrsOf (types.submodule bottleModule);
      default = { };
    };

    adhocPluginsPath = lib.mkOption {
      type = types.singleLineStr;
      default = ".wplugs";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.yabridge pkgs.yabridgectl activation ];

      home.file."${cfg.adhocPluginsPath}/.keep".text = "";

      xdg.configFile."yabridgectl/config.toml".text = let
        pluginDirs = lib.mapAttrsToList (_: bottle: "${bottle.prefix}/drive_c/${pluginsDir}") bottles
          ++ [ "${home}/${cfg.adhocPluginsPath}" ];
        quoted = lib.concatMapStringsSep ", " (x: ''"${x}"'') pluginDirs;
      in "plugin_dirs = [${quoted}]";
    };

    networking.extraHosts = lib.concatLines (
      lib.concatMap (bottle: bottle.hosts) (lib.attrValues cfg.bottles)
    );
  };
}
