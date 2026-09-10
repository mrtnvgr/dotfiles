{ ... }: {
  nix.settings = {
    substituters = [
      "https://mrtnvgr.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://bandithedoge.cachix.org"
    ];

    trusted-public-keys = [
      "mrtnvgr.cachix.org-1:zV5Vv57wyo/NNdiLZg0IMjQSLLL0pkEbfeltQ0F4kL8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "bandithedoge.cachix.org-1:ZtcHw1anyEa4t6H8m3o/ctYFrwYFPAwoENSvofamE6g="
    ];
  };
}
