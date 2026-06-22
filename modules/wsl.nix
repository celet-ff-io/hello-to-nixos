# WSL configurations
# Do not enable this on any envrionment without WSL
{ config, lib, ... }:
lib.mkIf config.wsl.enable {
  wsl = {
    ssh-agent.enable = true;
    interop.register = true;
  };

  htn3.tmux.status.network-connectivity.enable = false;

  environment.shellAliases = {
    xdg-open = "explorer.exe";
  };
}
