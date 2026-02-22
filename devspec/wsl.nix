# WSL configurations
# Do not enable this on any envrionment except WSL
defaultUser:
{ ... }: {
  wsl = {
    enable = true;
    defaultUser = defaultUser;
    ssh-agent.enable = true;
    interop.register = true;
  };

  tmux.status.network-connectivity.enable = false;
}
