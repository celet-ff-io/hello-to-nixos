# Ariete's Hello to NixOS

My NixOS configuration. A configuration without Home Manager.

## Properties

See [docs](docs/docs.md) for details.

### Programs mainly included

* [tuigreet](https://github.com/apognu/tuigreet)
  on [greetd](https://github.com/kennylevinsen/greetd) as console greeter
* [KMSCON](https://github.com/kmscon/kmscon) instead of default VT,
  to display the [nerd font](https://www.nerdfonts.com/) JetBrainsMono Nerd Font
* [Zsh](https://www.zsh.org/) as shell
* [tmux](https://tmux.info/)
* [nnn (n³)](https://github.com/jarun/nnn)
  and [Yazi](https://yazi-rs.github.io/) as file manager
* [neovim](https://neovim.io/) as editor
* [w3m](https://w3m.sourceforge.net/) as TUI browser
* and more...

With [Wayland](https://wayland.freedesktop.org/)
[Cage](https://www.hjdskes.nl/projects/cage/)
environment:

* [Foot](https://codeberg.org/dnkl/foot) as terminal
* [Kitty](https://sw.kovidgoyal.net/kitty/) as terminal
if you want rich features like background image (works as "wallpaper" in Cage)
* [Firefox](https://www.firefox.com/)
* [Zed editor](https://zed.dev/) as optional editor
* and more...

### Features

#### For programs

* [Oh My Zsh](https://ohmyz.sh/) with theme [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

* `zsh` plugin [ZSH-VI-MODE](https://github.com/jeffreytse/zsh-vi-mode)
with `jk` as escape key for insert mode

* `zsh` with [quitcd](https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_sh_zsh)
of `nnn` (use with `n` in shell) and `y` for yazi

* Alias `to` for `tmux new-session -A -s`

* tmux status-right with network connectivity, battery (optional) and time

#### Other

* Vi-mode `zsh` and `tmux`

* Nix-channel `substituters` to some mirrors in *China Mainland*.

## Install

1. Clone this repository and let shell variable `HTN` be its path.

2. Backup your current `/etc/nixos/configuration.nix` or `flake.nix`.

3. Clone `common.nix`, and `flake.nix` from `$HTN/examples/` to `/etc/nixos/`.
  Change the `"/path/to/hello-to-nixos"` in your configuration copied from template
  to the value of `"$HTN"` in shell,
  and **modify your new configuration** according to your backup made in step 2.

4. Rebuild and switch.

5. If you use NixOS on a **real hardware** instead of WSL,
  then reboot to apply the changes on boot, terminal and more;  
  If you use NixOS on WSL, then shutdown the instance and start it.

6. Configure `oh-my-zsh` and `p10k` following their interactive configurations.

### Example

Install the `hello-to-nixos` configuration:

```bash
# Clone repository
HTN='/path/to/hello-to-nixos' # No trailing "/" here
mkdir -p "$HTN"
git clone https://github.com/celet-ff-io/hello-to-nixos.git "$HTN"

# Install configuration
sudo chown -R $(whoami):wheel /etc/nixos
cd /etc/nixos
cp ./configuration.nix ./configuration.nix.bak
cp "$HTN/examples/common.nix" ./common.nix
```

Install the rest configuration **with flakes**:

```bash
cp "$HTN/examples/flake.nix" ./flake.nix
```

Then modify the `configuration.nix` according to your current NixOS configuration.

Rebuild your system:

```bash
sudo nixos-rebuild switch --switch --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store"
```

After the first success,
`substituters` will be set in configuration of this repository,
and you do not need to add `--option substituters` anymore.

Once everything is ready, use `sudo reboot` to reboot.
After your device starts, you should see interface of `tuigreet` for login.

Configure `oh-my-zsh` and `p10k` following their interactive configurations
after the `zsh` starts.

## Configuration

You configure it mainly in the `/etc/nixos` directory
just like what you do ordinarily in NixOS.

### Extra configuration with nix

See *# Options* in [template](template-configuration.nix).

### About some configuration not with nix

* For `nvim` (the `$EDITOR`),
  use [LazyVim](https://www.lazyvim.org/) is recommended.

* If you choose [kitty](https://sw.kovidgoyal.net/kitty/) in `/etc/nixos/configuration.nix`,
then you
[configure](https://sw.kovidgoyal.net/kitty/overview/#configuring-kitty)
it not in `/etc/nixos` but in `~/.config/kitty/kitty.conf` or pressing `ctrl+shift+f2`.

## License

This repository is licensed under MIT license.
Please see `LICENSE` for further information.
