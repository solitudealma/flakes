{ pkgs, ... }: {
  home = { packages = with pkgs; [ wl-clipboard wl-clip-persist wtype ]; };

  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [ rofi-calc ];
    };
  };
}
