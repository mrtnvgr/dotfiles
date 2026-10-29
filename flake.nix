{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    # Automatic ISOs CI
    generators.url = "github:nix-community/nixos-generators";
    generators.inputs.nixpkgs.follows = "nixpkgs";

    bandithedoge-pkgs.url = "github:bandithedoge/nur-packages";
    bandithedoge-pkgs.inputs.nixpkgs.follows = "nixpkgs";
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
      packages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        nixpkgs.lib.filterAttrs
          (_: value: nixpkgs.lib.isDerivation value)
          (import ./pkgs { inherit pkgs; }));

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

  nixConfig = {
    extra-substituters = [
      "https://mrtnvgr.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://bandithedoge.cachix.org"
    ];

    extra-trusted-public-keys = [
      "mrtnvgr.cachix.org-1:zV5Vv57wyo/NNdiLZg0IMjQSLLL0pkEbfeltQ0F4kL8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "bandithedoge.cachix.org-1:ZtcHw1anyEa4t6H8m3o/ctYFrwYFPAwoENSvofamE6g="
    ];
  };
}
