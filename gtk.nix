{ config, lib, pkgs, ... }:
let
  buttonLayout = if config.wayland.windowManager.hyprland.enable then
    "appmenu"
  else
    "close,minimize,maximize";
in {
  # TODO: Migrate to Colloid-gtk-theme 2024-06-18 or newer; now has catppuccin colors
  # - https://github.com/vinceliuice/Colloid-gtk-theme/releases/tag/2024-06-18
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-size = 20;
      cursor-theme = "Bibata-Modern-Ice";
      gtk-theme = "Nordic";
      icon-theme = "Papirus-Light";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "${buttonLayout}";
      theme = "Nordic";
    };

    "org/pantheon/desktop/gala/appearance" = {
      button-layout = "${buttonLayout}";
    };
  };
  gtk = {
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    enable = true;
    font = {
      name = "Maple Mono NF CN";
      package = pkgs.maple-mono.NF-CN;
    };
    gtk2 = {
      configLocation = "${config.xdg.configHome}/.gtkrc-2.0";
      extraConfig = ''
        gtk-application-prefer-dark-theme = 1
        gtk-button-images = 1
      '';
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-button-images = 1;
      };
    };
    gtk4 = { extraConfig = { }; };
    iconTheme = {
      name = "Papirus-Light";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
  };
  home = {
    packages = with pkgs; [ papirus-folders ];
    pointerCursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      x11.enable = true;
      x11.defaultCursor = "Bibata-Modern-Ice";
      size = 20;
      gtk.enable = true;
    };
  };
}
