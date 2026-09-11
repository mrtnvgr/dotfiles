{ pkgs, ... }: let
  creds = import ./secrets/uni.nix;
in {
  networking.networkmanager.ensureProfiles.profiles.UniversityStudent = {
    connection.id = "UniversityStudent";
    connection.type = "wifi";

    wifi.ssid = "UniversityStudent";
    wifi-security.key-mgmt = "wpa-eap";

    "802-1x" = {
      inherit (creds) identity password;

      eap = "peap;";
      phase2-auth = "mschapv2";
      ca-cert = toString (pkgs.fetchurl {
        url = "https://pki.university.innopolis.ru/iu_RCA.crt";
        hash = "sha256-mCenykCC3KQwIRcdpz8N2asLleHYgdkWNbgiM9NTfDg=";
      });
    };
  };

  environment.systemPackages = [
    (pkgs.quartus-prime-lite.override {
      supportedDevices = [
        "Cyclone IV"
        "MAX 10 FPGA"
      ];
    })
  ];

  services.udev.extraRules = ''
    # Altera USB-Blaster
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", MODE="0666"

    # Altera USB-Blaster II
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", MODE="0666"
  '';
}
