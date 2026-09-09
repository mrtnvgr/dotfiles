{ inputs, pkgs, ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./secrets/bitwig.nix

    ./uni.nix

    inputs.amnezia-vpn.nixosModules.default
    { programs.amnezia-vpn.enable = true; }
  ];

  modules.laptop = {
    enable = true;
    # TODO: hibernation
  };

  modules.desktop = {
    trash.enable = true;

    boot.silent = true;

    dev.enable = true;
    dev.c.enable = true;

    # apps.calibre.enable = true;
    apps.openutau.enable = true;

    daws.bitwig.enable = true;
    audio.samples = "Samples";

    audio = {
      rt.enable = true;

      plugins.native.enable = true;
      # plugins.wine.enable = true; # TODO: remove?
    };
  };

  services.getty.greetingLine = builtins.readFile ./castle;

  # Presets
  # systemd.user.tmpfiles.rules = [
  #   "L /home/${user}/.local/share/vital/User/Presets - - - - /home/${user}/Samples/Presets/Vital"
  #   "L \"/home/${user}/.local/documents/Surge XT/Patches\" - - - - /home/${user}/Samples/Presets/Surge"
  #   "L \"/home/${user}/.config/DecentSampler/Sample Libraries\" - - - - /home/${user}/Samples/Presets/DecentSampler"
  #
  #   "L \"/home/${user}/.local/documents/Surge XT/Wavetables\" - - - - /home/${user}/Samples/Wavetables"
  #   # TODO: link wavetables for vital
  # ];
  # TODO: Set dark mode by default here (/home/user/.local/documents/Surge XT/SurgeXTUserDefaults.xml)
  # TODO: move to modules.desktop.audio = {
  #   wavetables = "...";
  #
  #   plugins.vital.userPresets = "...";
  #   plugins.surge.userPresets = "...";
  #   plugins.vital.userWavetables = "...";
  #   plugins.surge.userWavetables = "...";
  # };

  environment.systemPackages = with pkgs; [
    tor-browser
    qbittorrent

    (quartus-prime-lite.override {
      supportedDevices = [
        "Cyclone IV"
        "MAX 10 FPGA"
      ];
    })
  ];

  # NOTE: use oci-containers
  modules.generic.vms.w1 = {
    os = "windows";
    # TODO: disks, size?
    # TODO: users.user.password = "password";
    # TODO: exposeFirewall
    autostart = false;
  };

  # TODO: modules.generic.moviesPath = "..."? (if set enable jellyfin)
  # services.jellyfin = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # TODO: migrate to btrfs, check out vimjoyer auto partition video
}
