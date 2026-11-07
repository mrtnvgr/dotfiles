{ pkgs, lib, config, user, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [ alsa-utils ];
    users.users.${user}.extraGroups = [ "audio" ];
  };
}
