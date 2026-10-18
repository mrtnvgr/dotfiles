{ user, config, lib, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    users.users.${user}.extraGroups = [ "kvm" ];
  };
}
