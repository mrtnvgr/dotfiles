# A lot was taken from https://bogomolov.work/blog/posts/howto-wireguard
# Thank you!

{ lib, config, ... }:
let
  cfg = config.modules.server.misc.wireguard;

  keyOption = lib.mkOption { type = lib.types.singleLineStr; };

  userOption = lib.types.submodule {
    options = {
      keys.public = keyOption;
      keys.private = keyOption;
    };
  };

  wgPort = config.networking.wg-quick.interfaces.wg0.listenPort;
in {
  options.modules.server.misc.wireguard = {
    enable = lib.mkEnableOption "WireGuard";

    serverKeys = {
      public = keyOption;
      private = keyOption;
    };

    users = lib.mkOption {
      type = lib.types.attrsOf userOption;
      default = {};
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 51820;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "expose port in firewall";
    };

    publicInterface = lib.mkOption {
      type = lib.types.singleLineStr;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.wg-quick.interfaces.wg0 = {
      listenPort = cfg.port;

      address = [ "10.1.2.1/24" ];
      privateKey = cfg.serverKeys.private;

      # TODO: for file generation
      # lib.mapAttrsToList (name: x: x // { inherit name; }) cfg.users;

      # [Interface]
      # PrivateKey = <client private key>
      # Address = 10.1.2.${toString (i+1)}/24
      # DNS = {SERVER_PUBLIC_IP}
      #
      # [Peer]
      # PublicKey = {SERVER_PUBLIC_KEY}
      # Endpoint = {PUBLIC_IP}:{PORT}
      # AllowedIPs = 0.0.0.0/0

      peers = lib.imap1 (i: x: {
        publicKey = x.keys.public;
        allowedIPs = [ "10.1.2.${toString (i+1)}/32" ];
      }) (builtins.attrValues cfg.users);
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

    networking.firewall.allowedUDPPorts = lib.optional cfg.openFirewall wgPort;

    # https://wiki.nixos.org/wiki/WireGuard#wg-quick_issues_with_NetworkManager
    # services.resolved.enable = true;
  };
}
