# https://github.com/NixOS/nixpkgs/issues/336089#issuecomment-2308353273
_: {
  boot.tmp.cleanOnBoot = true;

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };
}
