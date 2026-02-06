# Developer extras
{ pkgs, ... }: {
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    gnumake
    gcc
    binutils
    pkg-config
    gdb

    cargo

    go

    openjdk21
    gradle

    (python313.withPackages (ps: with ps; [ pip ]))
    uv

    nodejs
    corepack

    lua5_1
    luarocks

    ruby
    php

    julia

    frp
    sqlite

    p7zip
    gh
    lazygit
  ];

  environment.variables = {
    GO111MODULE = "on";
    GOPROXY = "https://goproxy.cn,direct";
    UV_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
  };

  environment.sessionVariables = {
    CARGO_TARGET_DIR = "$HOME/.cache/cargo-target";
  };

  programs.git = {
    enable = true;

    config = {
      init = { defaultBranch = "main"; };
      core = { editor = "nvim"; };
    };
  };
}
