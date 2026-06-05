# Developer extras
{ pkgs, ... }:
{
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    gnumake
    cmake
    ninja
    gcc
    clang
    clang-tools
    llvmPackages.lld
    lldb
    binutils
    pkg-config
    gdb
    bear

    rustup

    go

    openjdk21
    gradle

    (python313.withPackages (ps: with ps; [ pip ]))
    uv

    nodejs
    corepack
    pnpm
    bun

    lua5_1
    luarocks

    ruby
    php

    julia

    frp
    sqlite

    p7zip
    gh

    docker-compose
    arion
    lazydocker
    podman-tui
  ];

  environment.sessionVariables = {
    GO111MODULE = "on";
    GOPROXY = "https://goproxy.cn,direct";

    UV_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";

    # no RUSTUP_UPDATE_ROOT
    RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
    CARGO_TARGET_DIR = "$HOME/.cache/cargo-target";
    CARGO_INSTALL_ROOT = "$HOME/.local";
  };

  programs = {
    git = {
      enable = true;

      config = {
        init = {
          defaultBranch = "main";
        };
        core = {
          editor = "nvim";
        };
      };
    };

    direnv.enable = true;

    nix-index.enable = true;
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
}
