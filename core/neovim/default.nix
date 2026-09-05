{ inputs, user, ... }: {
  home-manager.users.${user} = {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;

      performance.byteCompileLua = {
        enable = true;
        initLua = true;
        luaLib = true;
        nvimRuntime = true;
        plugins = true;
      };
    };

    # replaces nvim with v
    # HACK: find a better way to do this with `nixvim.defaultEditor` etc.
    programs.bash = {
      sessionVariables = {
        EDITOR = "/home/${user}/.nix-profile/bin/nvim";
        VISUAL = "$EDITOR";
      };

      shellAliases.v = "$EDITOR";

      bashrcExtra = ''
        nvim() { :; }
      '';
    };
  };

  imports = [
    ./options.nix
    ./autocmds.nix
    ./keymaps.nix
    ./plugins.nix
    ./filetypes.nix
  ];
}
