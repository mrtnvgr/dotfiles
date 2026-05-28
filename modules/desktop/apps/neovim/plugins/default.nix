{ ... }: {
  imports = [
    ./lsp

    ./treesitter.nix
    ./picker
    ./flash.nix
    ./lualine.nix
    ./gitsigns.nix
    ./completion.nix
    ./autopairs.nix
    ./lastplace.nix
    ./oil.nix
    ./todo.nix
    ./colorizer.nix
    ./arrow.nix
    ./langmapper.nix
  ];
}
