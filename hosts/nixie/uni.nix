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
}
