{ pkgs, lib, ... }: {
  programs.amnezia-vpn = {
    enable = true;
    package = (import ../../pkgs { inherit pkgs; }).amnezia-vpn;
  };

  systemd.tmpfiles.rules = [
    "L+ /usr/bin/wg-quick  - - - - ${lib.getExe' pkgs.wireguard-tools "wg-quick"}"
    "L+ /usr/bin/awg-quick - - - - ${lib.getExe' pkgs.amneziawg-tools "awg-quick"}"
  ];

  systemd.services.AmneziaVPN.path = with pkgs; [
    wireguard-tools
    amneziawg-tools
  ];
}
