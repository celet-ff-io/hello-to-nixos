{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.htn3.optional.developer;
in
lib.mkIf (config.htn3.enable && cfg.enable) {
  environment = {
    systemPackages = with pkgs; [
      gnumake
      cmake
      ninja
      gcc
      clang
      clang-tools
      llvmPackages.lld
      lldb
      binutils
      gdb
      bear

      pkg-config
      openssl.dev

      rustup

      go
      protobuf
      buf

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

    sessionVariables = {
      PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig:/run/current-system/sw/share/pkgconfig";

      GO111MODULE = "on";
      GOPROXY = "https://goproxy.cn,direct";

      UV_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";

      # no RUSTUP_UPDATE_ROOT
      RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup";
      RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      CARGO_TARGET_DIR = "$HOME/.cache/cargo";
      CARGO_INSTALL_ROOT = "$HOME/.local";

      DOCKER_HOST = "unix:///run/user/\${UID}/podman/podman.sock";
    };
  };

  programs = {
    git = {
      enable = true;

      config = {
        init = {
          defaultBranch = "main";
        };
        core = {
          editor = config.environment.sessionVariables.EDITOR;
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
