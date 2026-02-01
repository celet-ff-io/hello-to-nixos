# Gooddays' Hello to NixOS

My NixOS configuration. A configuration without Home Manager or Flakes.

## Properties

See [docs](docs/docs.md) for details.

### Programs mainly included

* [tuigreet](https://github.com/apognu/tuigreet) on [greetd](https://github.com/kennylevinsen/greetd) as console greeter
* [KMSCON](https://github.com/kmscon/kmscon) instead of default terminal, to display the [nerd font](https://www.nerdfonts.com/) JetBrainsMono Nerd Font
* [Zsh](https://www.zsh.org/) as shell
* [tmux](https://tmux.info/)
* [nnn (n³)](https://github.com/jarun/nnn) and [Yazi](https://yazi-rs.github.io/) as file manager
* [neovim](https://neovim.io/) as editor
* [w3m](https://w3m.sourceforge.net/) as TUI browser
* and more...

With [Wayland](https://wayland.freedesktop.org/) [Cage](https://www.hjdskes.nl/projects/cage/) environment (when foot or kitty enabled):

* [Foot](https://codeberg.org/dnkl/foot) as terminal
* [Kitty](https://sw.kovidgoyal.net/kitty/) as terminal if you want rich features like background image (works as "wallpaper" in Cage)
* [Firefox](https://www.firefox.com/)
* [Zed editor](https://zed.dev/) as optional editor
* and more...

### Features

#### For programs

* [Oh My Zsh](https://ohmyz.sh/) with theme [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

* Zsh plugin [ZSH-VI-MODE](https://github.com/jeffreytse/zsh-vi-mode) with `jk` as escape key for insert mode

* Zsh with [quitcd](https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_sh_zsh) of nnn (use with `n` in shell) and `y` for yazi

* Alias `to` for `tmux new-session -A -s`

* tmux status-right with network connectivity, battery (optional) and time

#### Other

* Vim-mode zsh and tmux

* Nix-channel substituters **forced** to mirrors in *China Mainland*.

## Install

1. Clone this repository as `/etc/nixos`

2. Clone `template-configuration.nix` to `configuration.nix` and **modify it** according to where your NixOS runs currently

3. Rebuild

4. If you use NixOS on **real hardware** instead of WSL, then reboot to apply the changes on boot, terminal and more;
If you use NixOS on WSL, then shutdown the instance and start it

5. Configure oh-my-zsh and p10k following their interactive configurations

### Example

```bash
cd /etc
sudo mv nixos nixos.bak
sudo mkdir nixos
sudo chown $(whoami):wheel nixos
cd nixos
git clone https://github.com/celet-ff-io/hello-to-nixos.git
mv hello-to-nixos/{*,.*} .
rmdir hello-to-nixos
cp template.conf configuration.conf
```

Then modify the `configuration.conf` according to where your NixOS runs currently.

```bash
# Make sure you have confiured configuration.conf
sudo nixos-rebuild switch --option substituters https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store
sudo reboot # This will reboot your device!
```

After your device starts, you should see tuigreet for login.

Configure oh-my-zsh and p10k following their interactive configurations after the zsh starts.

## Configuration

You configure it mainly in the `/etc/nixos` directory just like what you do ordinarily in NixOS.

### Extra configuration with nix

See # Options in [template](template-configuration.nix) for those I declared in file `option`.

### Configuration not with nix

* For nvim (the `$EDITOR`), I recommend to [install](https://www.lazyvim.org/installation) [LazyVim](https://www.lazyvim.org/).

* If you choose [kitty](https://sw.kovidgoyal.net/kitty/) in `/etc/nixos/configuration.nix`,
then you [configure](https://sw.kovidgoyal.net/kitty/overview/#configuring-kitty) it not in `/etc/nixos` but in `~/.config/kitty/kitty.conf` or pressing `ctrl+shift+f2`.

## License

This repository is licensed under MIT license. Please see [LICENSE]() for further information.

