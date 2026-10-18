{ ... }: {
  imports = [
    ./bootloader.nix
    ./nix.nix
    ./packages.nix
    ./fat.nix
    ./overlays.nix
    ./bcache.nix
    ./home-manager.nix
    ./time-zone.nix
    ./nice-build.nix
    ./users.nix
    ./network.nix
    ./registry.nix
    ./git.nix
    ./ssh.nix
    ./neovim
    ./shell.nix
    ./archiving.nix
    ./gpg.nix
    ./kernel.nix
    ./gc-whitelist.nix
    ./logs.nix
    ./temp.nix
    ./hostname.nix
    ./lix.nix
  ];
}
