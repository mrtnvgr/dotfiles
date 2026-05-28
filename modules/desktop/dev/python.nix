{ pkgs, lib, config, user, ... }: let
  defaultPackages = ps: with ps; [
    requests
    datetime
    beautifulsoup4
    pillow
    gitpython
    numpy
  ];

  cfg = config.modules.desktop.dev.python;
in
{
  options.modules.desktop.dev.python = {
    enable = lib.mkEnableOption "python";
    packages = lib.mkOption {
      type = with lib.types; functionTo (listOf package);
      default = defaultPackages;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ (pkgs.python3.withPackages cfg.packages) ];

      programs.nixvim.plugins = {
        lsp.servers.basedpyright = {
          enable = true;

          # Disables annoying `Any` type reports
          # (Disable this and type `foo = ` in a Python file.)
          config.analysis.reportAny = "none";
        };
      };
    };
  };
}
