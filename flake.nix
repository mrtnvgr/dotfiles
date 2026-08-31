{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wine.url = "github:nixos/nixpkgs/b73c2221a46c13557b1b3be9c2070cc42cf01eb3";

    # My repo of custom packages and functions
    mrtnvgr = {
      url = "github:mrtnvgr/nurpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Supercharged dotfiles :)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Colors! Yay!
    oxidec.url = "github:mrtnvgr/oxidec";

    # Nix-friendly neovim
    nixvim.url = "github:nix-community/nixvim";

    nix-gaming.url = "github:fufexan/nix-gaming";

    catppuccin-renoise.url = "github:catppuccin/renoise";
    catppuccin-renoise.flake = false;

    # Automatic ISOs CI
    generators.url = "github:nix-community/nixos-generators";
    generators.inputs.nixpkgs.follows = "nixpkgs";

    mrtnvgr-actions.url = "github:mrtnvgr/actions.nvim";
    mrtnvgr-actions.flake = false;
  };

  outputs = { nixpkgs, ... } @ inputs:
    let
      mkSystem = user: hostname:
        nixpkgs.lib.nixosSystem {
          modules = [
            ./core

            ./modules

            ./hosts/${hostname}/hardware.nix
            ./hosts/${hostname}
          ];

          specialArgs = { inherit inputs user hostname; };
        };
    in
    {
      nixosConfigurations = {
        # <hostname> = mkSystem <username> <hostname>;

        # Desktops
        nixie = mkSystem "user" "nixie";
        thlix = mkSystem "user" "thlix";
        minix = mkSystem "user" "minix";

        # Servers
        cloud = mkSystem "user" "cloud";
      };
    };
}
