{ ... }: {
  services.logrotate.enable = true;
  services.journald.settings.Journal.SystemMaxUse = "256M";
}
