# WSL configurations
# Do not enable this on any envrionment without WSL
{ ... }:
{
  wsl = {
    enable = true;
    ssh-agent.enable = true;
    interop.register = true;
  };

  tmux.status.network-connectivity.enable = false;

  environment.shellAliases = {
    xdg-open = "explorer.exe";
  };
}
