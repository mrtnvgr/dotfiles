{ ... }: {
  imports = [
    ./lsp

    ./treesitter.nix
    ./picker.nix
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
    ./tabularize.nix
  ];
}
