{ inputs, user, ... }: {
  home-manager.users.${user} = {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      performance.byteCompileLua = {
        enable = true;
        initLua = true;
        luaLib = true;
        nvimRuntime = true;
        plugins = true;
      };
    };

    programs.bash.shellAliases.v = "nvim";
  };

  imports = [
    ./options.nix
    ./autocmds.nix
    ./keymaps.nix
    ./plugins.nix
    ./filetypes.nix
  ];
}
