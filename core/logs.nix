{ ... }: {
  services.logrotate.enable = true;
  services.journald.extraConfig = "SystemMaxUse = 256M";
}
