{ lib, config, ... }: let
  cfg = config.modules.desktop.boot;
in {
  options.modules.desktop.boot.silent = lib.mkEnableOption "silent boot";

  config = lib.mkIf cfg.silent {
    # https://github.com/NixOS/nixpkgs/issues/32555#issuecomment-1678447958
    boot.kernelParams = [ "console=tty2" ];
  };
}
