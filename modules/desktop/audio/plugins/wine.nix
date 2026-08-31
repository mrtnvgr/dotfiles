{ inputs, pkgs, config, lib, user, ... }: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.modules.desktop.audio.plugins.wine;

  yabridge = pkgs.yabridge.override { wine = cfg.package; };
  yabridgectl = pkgs.yabridgectl.override { wine = cfg.package; };

  bottleOptions = {
    tricks = mkOption {
      type = with types; listOf str;
      default = [];
    };

    plugins = mkOption {
      type = with types; listOf path;
      default = [];
    };

    data = mkOption {
      type = types.listOf (types.submodule {
        options = {
          src = mkOption { type = types.path; };
          dest = mkOption { type = types.str; };
          symlink = mkOption { type = types.bool; default = true; };
          linkContents = mkOption { type = types.bool; default = false; };
        };
      });

      default = [];
    };

    regFiles = mkOption {
      type = with types; listOf path;
      default = [];
    };

    hosts = mkOption {
      type = types.lines;
      default = "";
    };

    postScript = mkOption {
      type = types.lines;
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

  wine-audio-plugins-activate = pkgs.writeScriptBin "wine-audio-plugins-activate" ''
    ${lib.concatMapStringsSep "\n" (x: "${x}/bin/*") envs}
    yabridgectl sync -p -n
  '';
in {
  options.modules.desktop.audio.plugins.wine = {
    enable = mkEnableOption "Windows audio plugins through WINE";

    package = mkOption {
      type = types.package;
      default = inputs.nixpkgs-wine.legacyPackages.${pkgs.stdenv.hostPlatform.system}.wineWowPackages.stagingFull;
    };

    bottles = mkOption {
      type = with types; attrsOf (submodule {
        options = bottleOptions;
      });
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = { lib, ... }: {
      home.packages = [ yabridge yabridgectl wine-audio-plugins-activate ];

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
