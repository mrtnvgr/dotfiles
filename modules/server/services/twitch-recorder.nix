{ config, pkgs, lib, user, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;

  cfg = config.modules.server.services.twitch-recorder;

  serviceUser = "twitch-recorder";
  serviceGroup = "twitch-recorder";

  mkChannelService = channel: {
    "twitch-recorder-${channel}" = {
      description = "Twitch live recorder for ${channel}";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        streamlink
        ffmpeg-headless
        chromium
        coreutils
      ];

      environment = {
        HOME = "/var/lib/${serviceUser}/${channel}";
        XDG_CACHE_HOME = "/var/cache/${serviceUser}/${channel}";
        XDG_CONFIG_HOME = "/var/lib/${serviceUser}/${channel}/.config";
        XDG_DATA_HOME = "/var/lib/${serviceUser}/${channel}/.local/share";
        XDG_RUNTIME_DIR = "/run/${serviceUser}/${channel}";
      };

      unitConfig.StartLimitIntervalSec = 0;

      serviceConfig = {
        User = serviceUser;
        Group = serviceGroup;
        UMask = "0002";

        StateDirectory = "${serviceUser}/${channel}";
        CacheDirectory = "${serviceUser}/${channel}";
        RuntimeDirectory = "${serviceUser}/${channel}";
        RuntimeDirectoryMode = "0700";

        WorkingDirectory = "/var/lib/${serviceUser}/${channel}";

        Restart = "always";
        RestartSec = 10;
        KillSignal = "SIGINT";
        TimeoutStopSec = 60;

        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ReadWritePaths = [ cfg.outputDir ];
      };

      script = ''
        exec ${pkgs.streamlink}/bin/streamlink \
          --no-config \
          --twitch-supported-codecs h264 \
          --hls-live-restart \
          --retry-streams ${toString cfg.pollInterval} \
          --retry-max 0 \
          --stream-segment-attempts 10 \
          --stream-segment-timeout 30 \
          --hls-playlist-reload-attempts 10 \
          --retry-open 3 \
          --progress no \
          --skip \
          --webbrowser-headless=yes \
          --webbrowser-executable ${pkgs.chromium}/bin/chromium \
          --ffmpeg-ffmpeg ${pkgs.ffmpeg-headless}/bin/ffmpeg \
          --output "${cfg.outputDir}/{author}/{author}-{time:%Y-%m-%d_%H-%M-%S}.ts" \
          "https://www.twitch.tv/${channel}" "${cfg.quality}"
      '';
    };
  };
in {
  options.modules.server.services.twitch-recorder = {
    enable = mkEnableOption "Twitch live stream recorder";

    channels = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Twitch channel logins (the name after twitch.tv/) to record.
      '';
      example = [ "somestreamer" ];
    };

    quality = mkOption {
      type = types.str;
      default = "best";
      description = ''
        Streamlink stream selection. "best" records the highest available
        H.264 stream, usually 1080p60. A comma-separated fallback such as
        "1080p60,best" is also accepted.
      '';
      example = "1080p60,best";
    };

    outputDir = mkOption {
      type = types.str;
      default = "/var/lib/twitch-recordings";
      description = ''
        Directory where recordings are written. Recordings are never deleted
        automatically.
      '';
    };

    pollInterval = mkOption {
      type = types.int;
      default = 30;
      description = ''
        Seconds between checks while the channel is offline.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.channels != [];
        message = "modules.server.services.twitch-recorder.channels must not be empty.";
      }
      {
        assertion = cfg.pollInterval > 0;
        message = "modules.server.services.twitch-recorder.pollInterval must be positive.";
      }
      {
        assertion = lib.all (channel: builtins.match "[A-Za-z0-9_]+" channel != null) cfg.channels;
        message = "Twitch channel logins may only contain letters, digits, and underscores.";
      }
    ];

    users.groups.${serviceGroup} = {};
    users.users.${serviceUser} = {
      isSystemUser = true;
      group = serviceGroup;
      home = "/var/lib/${serviceUser}";
    };

    users.users.${user}.extraGroups = [ serviceGroup ];

    systemd.tmpfiles.rules = [
      "d ${cfg.outputDir} 2775 ${serviceUser} ${serviceGroup} -"
    ];

    systemd.services = lib.mkMerge (map mkChannelService cfg.channels);
  };
}
