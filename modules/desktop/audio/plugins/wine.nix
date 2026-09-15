{ inputs, config, pkgs, lib, user, ... }: let
  cfg = config.modules.desktop.audio.plugins.wine;

  bottleOptions = {
    tricks = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };

    plugins = lib.mkOption {
      type = with lib.types; listOf path;
      default = [];
    };

    data = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          src = lib.mkOption { type = lib.types.path; };
          dest = lib.mkOption { type = lib.types.str; };
          symlink = lib.mkOption { type = lib.types.bool; default = true; };
          linkContents = lib.mkOption { type = lib.types.bool; default = false; };
        };
      });

      default = [];
    };

    regFiles = lib.mkOption {
      type = with lib.types; listOf path;
      default = [];
    };

    hosts = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };

    postScript = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  mkEnv = name: bottle: pkgs.mkWineEnv {
    name = "audio-plugins_${name}";

    wine = cfg.package;
    inherit (bottle) tricks;

    # TODO: Migrate to runLocalCommand
    setupScript = let
      pluginScript = let
        pluginDirectory = "mkdir -p \"$HOME/.wine-nix/audio-plugins_${name}/dosdevices/c:/plugins\"";
        plugins = map (plugin: ''
          # TODO: use actual symlinking after https://github.com/robbert-vdh/yabridge/issues/454 is resolved
          cp -r "${plugin}" "$HOME/.wine-nix/audio-plugins_${name}/dosdevices/c:/plugins"
        '') bottle.plugins;
      in
        lib.concatStringsSep "\n" ([ pluginDirectory ] ++ plugins);

      dataScript = let
        getCopyMethod = x: if (x.symlink && !x.linkContents) then
          "ln -s"
        else if x.linkContents then
          "cp -rs"
        else
          "cp -r";

        mkData = x: /* bash */ ''
          DSTPATH="$HOME/.wine-nix/audio-plugins_${name}/drive_c/${x.dest}"
          mkdir -pv "$(dirname "$DSTPATH")"
          ${getCopyMethod x} -vf "${x.src}" "$DSTPATH"

          # https://superuser.com/a/91938
          find "$DSTPATH" -type d -exec chmod 755 {} +
          find "$DSTPATH" -type f -exec chmod 644 {} +
        '';
      in
        lib.concatMapStringsSep "\n" mkData bottle.data;

      regScript = lib.concatMapStringsSep "\n" (x: "wine regedit ${x}") bottle.regFiles;

      script = lib.concatStringsSep "\n" [
        "echo Symlinking plugin bins..."
        pluginScript

        "echo Copying data..."
        dataScript

        "echo Applying reg files..."
        regScript
      ];
    in script;

    inherit (bottle) postScript;
  };

  envs = lib.mapAttrsToList (name: bottle: mkEnv name bottle) cfg.bottles;

  # TODO: write a helper for wine env?:
  # wine-plugins sync, wine-plugins enter no_tricks
  wine-audio-plugins-activate = pkgs.writeScriptBin "wine-audio-plugins-activate" ''
    ${lib.concatMapStringsSep "\n" (x: "${x}/bin/*") envs}
    yabridgectl sync -p -n
  '';
in {
  options.modules.desktop.audio.plugins.wine = {
    enable = lib.mkEnableOption "Windows audio plugins through WINE";

    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.nixpkgs-wine.legacyPackages.${pkgs.stdenv.hostPlatform.system}.wineWowPackages.stagingFull;
    };

    bottles = lib.mkOption {
      type = with lib.types; attrsOf (submodule {
        options = bottleOptions;
      });
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = { lib, ... }: {
      home.packages = [ pkgs.yabridge pkgs.yabridgectl wine-audio-plugins-activate ];

      home.file.".config/yabridgectl/config.toml".text = let
        bottlePlugins = map (x: "/home/${user}/.wine-nix/${x.name}/dosdevices/c:/plugins") envs;
        plugins = bottlePlugins ++ [ "/home/${user}/.wplugs" ];
      in ''
        plugin_dirs = [${lib.concatStringsSep ", " (map (x: "\"${x}\"") plugins)}]
      '';

      # Do not isolate VST2 plugins
      home.file.".vst/yabridge/yabridge.toml".text = ''
        ["*"]
        group = "all"
      '';
    };

    networking.extraHosts = lib.concatStringsSep "\n" (lib.mapAttrsToList (_: x: x.hosts) cfg.bottles);

    # TODO: link files via hm
    # TODO: .wine-nix/plugins/{regs, data, plugins}
  };
}
