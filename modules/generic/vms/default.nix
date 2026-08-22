{ config, lib, pkgs, user, ... }: let
  cfg = config.modules.generic.vms;

  vmOptions = {
    os = lib.mkOption {
      type = lib.types.singleLineStr;
    };

    autostart = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.server.enable;
    };
  };

  mkVM = vm-name: vm: let
    func = if (vm.os == "windows") then mkWindowsVM else "BROKEN!!!!!!";
  in {
    autoStart = vm.autostart;
    capabilities."NET_ADMIN" = true;

    devices = [
      "/dev/kvm"
      "/dev/net/tun"
    ];

    serviceName = "vm-${vm-name}";
  } // (func vm-name vm);

  mkWindowsVM = vm-name: vm: let
    tiny10 = pkgs.fetchurl {
      url = "https://archive.org/download/tiny-10-23-h2/tiny10%20x64%2023h2.iso";
      hash = "sha256-oREWwGRdiS1qWnxYXswfoTqmb4x8xrA78fJ70WhgzDU=";
    };

    iso = if (vm.os == "windows") then tiny10 else "BROKEN!!!!";
  in {
    image = "dockurr/windows";
    imageFile = pkgs.dockerTools.pullImage {
      imageName = "dockurr/windows";
      finalImageName = "dockurr/windows";
      finalImageTag = "latest";

      # Get these hashes from
      # nix run nixpkgs#nix-prefetch-docker -- --image-name dockurr/windows
      imageDigest = "sha256:9c00d13a5db3f671c8b292967e87b3ace813d4a656257c5bc945ccd2afe1558d";
      hash = "sha256-pC0h5UIrLLrxzI5b60f+AB7jKmJlwjjFk5NgQYwAaDs=";
    };

    volumes = [
      "${iso}:/custom.iso"
      "${vm-name}-storage:/storage"
    ];

    environment = {
      KEYBOARD = "ru-RU";
      AUDIO = "Y";

      DISK_SIZE = "64G";

      USERNAME = user;
      PASSWORD = "password";
    };

    ports = [
      "8006:8006" # TODO: use enumerate and give each vm a unique port?
      "3389:3389/tcp"
      "3389:3389/udp"
    ];
  };
in {
  options.modules.generic.vms = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule { options = vmOptions; });
    default = {};
  };

  config.virtualisation.oci-containers.containers =
    lib.mapAttrs' (n: v: lib.nameValuePair n (mkVM n v)) cfg;

  # TODO: later on
  # TODO: `vm start ${name}`
  # TODO: `vm stop ${name}`
  # TODO: `vm status ${name}`
  # (TODO: maybe use just `sudo systemctl start vm-windows`)
}
