{ lib, pkgs, ... }: {
  imports = [ ./foot.nix ./gtk.nix ./zed-editor.nix ];
  # 注意修改这里的用户名与用户目录
  home.username = "solitudealma";
  home.homeDirectory = lib.mkDefault "/home/solitudealma";

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip

    # nix
    nixd
    nil

    qq
    wechat-uos
    element-desktop
    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop # replacement of htop/nmon
  ];

  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
