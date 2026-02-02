# Watchdog
{ ... }: {
  systemd.settings.Manager = {
    RebootWatchdogSec = "10min";
    RuntimeWatchdogSec = "30s";
  };
}
