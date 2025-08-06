{ config, lib, inputs, pkgs, username, ... }: {
  # 导入其他 Modules
  imports = [
    inputs.chaotic.nixosModules.default
    inputs.daeuniverse.nixosModules.dae
    inputs.mangowc.nixosModules.mango
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    # ./gnome.nix
  ];

  boot = {
    consoleLogLevel = lib.mkDefault 0;
    initrd.verbose = false;
    kernelModules = [ "vhost_vsock" ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;
    # Only enable the systemd-boot on installs, not live media (.ISO images)
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi = { canTouchEfiVariables = true; };
      grub = {
        configurationLimit = 100;
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        useOSProber = true;
      };
      timeout = 3;
    };
  };

  environment = {
    etc = { "backgrounds/4.png".source = ./4.png; };
    systemPackages = with pkgs; [
      # secret
      sops
      age

      nix-output-monitor

      baidupcs-go
      rmpc

      git
      vim
      wget
      foot
      firefox
      neovim
      zed-editor
      # 这里从 helix 这个 inputs 数据源安装了 helix 程序
      inputs.yazi.packages."${pkgs.system}".default
    ];
  };

  i18n = let
    fcitx5-rime-with-addons = ((pkgs.fcitx5-rime.override {
      librime = pkgs.librime.override {
        librime-lua = pkgs.librime-lua.override { lua = pkgs.lua5_4; };
      };
      rimeDataPkgs = with pkgs; [
        (callPackage ./rime-wanxiang-pro.nix { })
        (callPackage ./rime-wanxiang-pro-dict.nix { })
        (callPackage ./rime-solitudealma-custom.nix { })
      ];
    }).overrideAttrs (old: {
      # Prebuild schema data
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.parallel ];
      postInstall = (old.postInstall or "") + ''
        for F in $out/share/rime-data/*.schema.yaml; do
          echo "rime_deployer --compile "$F" $out/share/rime-data $out/share/rime-data $out/share/rime-data/build" >> parallel.lst
        done
        parallel -j$(nproc) < parallel.lst || true
      '';
    }));
  in {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-fluent
          fcitx5-lua
          fcitx5-gtk # gtk im module
          libsForQt5.fcitx5-qt
          fcitx5-rime-with-addons
        ];
        waylandFrontend = true;
        settings = {
          addons = {
            classicui.globalSection.Theme = "FluentLight";
            notifications = {
              globalSection = { };
              sections = {
                HiddenNotifications = { "0" = "wayland-diagnose-other"; };
              };
            };
          };
          inputMethod = {
            "Groups/0" = {
              # Group Name
              Name = "Default";
              # Layout
              "Default Layout" = "us";
              # Default Input Method
              DefaultIM = "rime";
            };
            "Groups/0/Items/0" = {
              # Name
              Name = "keyboard-us";
              # Layout
              Layout = "";
            };
            "Groups/0/Items/1" = {
              # Name
              Name = "rime";
              # Layout
              Layout = "";
            };
            GroupOrder = { "0" = "Default"; };
          };
          globalOptions = {
            Hotkey = {
              # 反复按切换键时进行轮换
              EnumerateWithTriggerKeys = "True";
              # 向前切换输入法
              # EnumerateForwardKeys=
              # 向后切换输入法
              # EnumerateBackwardKeys=
              # 轮换输入法时跳过第一个输入法
              EnumerateSkipFirst = "False";
            };
            "Hotkey/TriggerKeys" = {
              "0" = "Control+space";
              "1" = "Zenkaku_Hankaku";
              "2" = "Hangul";
            };
            "Hotkey/AltTriggerKeys" = { "0" = "Shift_L"; };
            "Hotkey/EnumerateGroupForwardKeys" = { "0" = "Super+space"; };
            "Hotkey/EnumerateGroupBackwardKeys" = {
              "0" = "Shift+Super+space";
            };
            "Hotkey/ActivateKeys" = { "0" = "Hangul_Hanja"; };
            "Hotkey/DeactivateKeys" = { "0" = "Hangul_Romaja"; };
            "Hotkey/PrevPage" = { "0" = "Up"; };
            "Hotkey/NextPage" = { "0" = "Down"; };
            "Hotkey/PrevCandidate" = { "0" = "Shift+Tab"; };
            "Hotkey/NextCandidate" = { "0" = "Tab"; };
            "Hotkey/TogglePreedit" = { "0" = "Control+Alt+P"; };
            Behavior = {
              # 默认状态为激活
              ActiveByDefault = "False";
              # 重新聚焦时重置状态
              resetStateWhenFocusIn = "No";
              # 共享输入状态
              ShareInputState = "No";
              # 在程序中显示预编辑文本
              PreeditEnabledByDefault = "False";
              # 切换输入法时显示输入法信息
              ShowInputMethodInformation = "True";
              # 在焦点更改时显示输入法信息
              showInputMethodInformationWhenFocusIn = "False";
              # 显示紧凑的输入法信息
              CompactInputMethodInformation = "True";
              # 显示第一个输入法的信息
              ShowFirstInputMethodInformation = "True";
              # 默认页大小
              DefaultPageSize = 5;
              # 覆盖 Xkb 选项
              OverrideXkbOption = "False";
              # 自定义 Xkb 选项
              # CustomXkbOption=
              # Force Enabled Addons
              # EnabledAddons=
              # Force Disabled Addons
              # DisabledAddons=
              # Preload input method to be used by default
              PreloadInputMethod = "True";
              # 允许在密码框中使用输入法
              AllowInputMethodForPassword = "False";
              # 输入密码时显示预编辑文本
              ShowPreeditForPassword = "False";
              # 保存用户数据的时间间隔（以分钟为单位）
              AutoSavePeriod = 30;
            };
          };
        };
      };
    };
  };

  nix = {
    # Opinionated: disable channels
    channel.enable = false;
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "flakes" "nix-command" ];
      # Disable global registry
      flake-registry = "";
      keep-outputs = true;
      keep-derivations = true;
      max-jobs = "auto";
      extra-trusted-substituters = map (n: "https://${n}.cachix.org") [
        "chaotic-nyx"
        "cosmic"
        "hyprland"
        "niri"
        "nix-community"
        "nixpkgs-wayland"
        "nur-pkgs"
        "yazi"
      ] ++ [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
        "https://mirror.sjtu.edu.cn/nix-channels/store" # SJTU - 上海交通大学 Mirror
        "https://mirrors.ustc.edu.cn/nix-channels/store" # USTC - 中国科学技术大学 Mirror
      ];
      extra-trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nur-pkgs.cachix.org-1:PAvPHVwmEBklQPwyNZfy4VQqQjzVIaFOkYYnmnKco78="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      ];
      trusted-users = [ "root" "${username}" ];
      warn-dirty = false;
    };
  };

  nixpkgs = { config = { allowUnfree = true; }; };

  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
  };
  environment.etc = {
    "dae/config.d/dns.dae" = {
      mode = "0640";
      source = ./dae/config.d/dns.dae;
    };
    "dae/config.d/group.dae" = {
      mode = "0640";
      source = ./dae/config.d/group.dae;
    };
    "dae/config.d/route.dae" = {
      mode = "0640";
      source = ./dae/config.d/route.dae;
    };
  };

  programs = {
    dconf.enable = true; # for gtk settting
    mango = { enable = true; };
    nh = {
      clean = {
        enable = true;
        extraArgs = "--keep-since 15d --keep 10";
      };
      enable = true;
      flake = "/home/${username}/flakes";
    };
  };
  sops = {
    age = {
      keyFile = "/home/solitudealma/.config/sops/age/keys.txt";
      generateKey = false;
    };
    defaultSopsFile = ./secrets/dae.yaml;
    secrets = {
      "subscription.dae" = {
        sopsFile = ./secrets/dae.yaml;
        mode = "0600";
        owner = "${username}";
      };
      # ssh_key = {
      #   mode = "0600";
      #   path = "/home/${username}/.ssh/id_ed25519";
      # };
    };
  };
  security = {
    pam.services = {
      greetd.enableGnomeKeyring = true;
      hyprlock = { };
    };
    polkit = { enable = true; };
  };
  services = {
    dae = {
      config = builtins.readFile ./dae/config.dae;
      enable = true;
      openFirewall = {
        enable = true;
        port = 12345;
      };
      assets = [ (pkgs.callPackage ./v2ray-rules-dat.nix { }) ];
    };
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command =
            "${lib.getExe pkgs.greetd.tuigreet} --remember --time --cmd ${
              lib.getExe inputs.mangowc.packages.${pkgs.system}.mango
            }";
          user = username;
        };
        default_session = initial_session;
      };
      vt = 1;
    };
    xserver = { xkb.layout = "us"; };
  };
  system.stateVersion = "24.11";
  time.timeZone = "Asia/Shanghai";
  users.users = {
    "${username}" = {
      description = username;
      ignoreShellProgramCheck = true;
      extraGroups = [ "input" "users" "wheel" ];
      homeMode = "0755";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ ];
      shell = pkgs.fish;
    };
  };
  xdg = {
    portal = {
      config = {
        dwl = {
          default = [ "wlr" "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      };
      xdgOpenUsePortal = true;
    };
    terminal-exec = {
      enable = true;
      settings = { default = [ "foot.desktop" ]; };
    };
  };
  # Fix xdg-portals opening URLs: https://github.com/NixOS/nixpkgs/issues/189851
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';
  systemd.services = let
    update = ''
      head="user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36"
      new_proxy=/etc/dae/proxy.d.new
      num=0
      check=1
      urls="$(cat ${config.sops.secrets."subscription.dae".path})"
      mkdir -p ''${new_proxy}
      for url in ''${urls}; do
        txt=''${new_proxy}/''${num}.txt
        config="''${new_proxy}/''${num}.dae"
        echo \'curl -LH \""''${head}"\" \""''${url}"\" -o \""''${txt}"\"\'
        curl -LH "''${head}" "''${url}" -o "''${txt}"
        echo End curl
        echo "" > ''${config}
        {
          echo 'subscription {'
          echo \ \ wget:\ \"file://proxy.d/''${num}.txt\"
          echo "}"
        } >> ''${config}
        if [[ ! -s ''${txt} ]]; then
          check=0
        fi
        chmod 0640 ''${txt}
        chmod 0640 ''${config}
        num=$((num+1))

        if [[ ''${check} -eq 0 ]]; then
          echo "''${txt}" is empty
          exit 103
        fi
      done
      if [[ -d /etc/dae/proxy.d ]]; then
        rm -rf /etc/proxy.d.old
        mv /etc/dae/proxy.d /etc/dae/proxy.d.old
      fi
      mv ''${new_proxy} /etc/dae/proxy.d
    '';
    updateScript = pkgs.writeShellApplication {
      name = "update.sh";
      runtimeInputs = with pkgs; [ coreutils curl ];
      text = ''
        mkdir -p /etc/proxy.d
        if [ -z "$(ls -A /etc/dae/proxy.d 2>/dev/null)" ]; then
          echo "No subscription file found in /etc/dae/proxy.d. Update now..."
          ${update}
        else
          echo "Found existing subscription files. Skipping immediate update."
        fi
      '';
    };
    updateForceScript = pkgs.writeShellApplication {
      name = "update-force.sh";
      runtimeInputs = with pkgs; [ coreutils curl ];
      text = ''
        ${update}
      '';
    };
  in {
    "update-dae-subscription-immediate" = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      before = [ "dae.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = [ "${updateScript}/bin/update.sh" ];
      };
      wantedBy = [ "multi-user.target" ];
    };
    "update-dae-subscription-force" = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStartPre = [ "-${pkgs.systemd}/bin/systemctl stop dae.service" ];
        ExecStartPost = [ "-${pkgs.systemd}/bin/systemctl start dae.service" ];
        ExecStart = [ "${updateForceScript}/bin/update-force.sh" ];
      };
    };
  };
}
