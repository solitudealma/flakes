{ ... }: {
  programs.foot = {
    enable = true;
    settings = {
      mouse-bindings = {
        # scrollback-up-mouse=BTN_WHEEL_BACK
        # scrollback-down-mouse=BTN_WHEEL_FORWARD
        # font-increase=Control+BTN_WHEEL_BACK
        # font-decrease=Control+BTN_WHEEL_FORWARD
        # selection-override-modifiers=Shift
        clipboard-paste = "BTN_RIGHT";
        # primary-paste=BTN_MIDDLE
        # select-begin=BTN_LEFT
        # select-begin-block=Control+BTN_LEFT
        select-extend = "BTN_LEFT-5"; # select-extend=BTN_RIGHT
        # select-extend-character-wise=Control+BTN_RIGHT
        # select-word=BTN_LEFT-2
        # select-word-whitespace=Control+BTN_LEFT-2
        # select-quote = BTN_LEFT-3
        # select-row=BTN_LEFT-4
      };
      environment = {
        # name=value
        TIMG_PIXELATION = "sixel";
        TERM = "foot";
      };
      main = {
        selection-target = "clipboard";
        term = "xterm-256color";
        font = "Maple Mono NF CN:size=11";
        dpi-aware = "yes";
      };
      url = {
        launch = "xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
        regex = ''
          (([a-z][[:alnum:]-]+:(/{1,3}|[a-z0-9%])|www[:digit:]{0,3}[.])([^[:space:](){}<>]+|\(([^[:space:](){}<>]+|(\([^[:space:](){}<>]+\)))*\)|\[([^]\[[:space:](){}<>]+|(\[[^]\[[:space:](){}<>]+\]))*\])+(\(([^[:space:](){}<>]+|(\([^[:space:](){}<>]+\)))*\)|\[([^]\[[:space:](){}<>]+|(\[[^]\[[:space:](){}<>]+\]))*\]|[^]\[[:space:]`!(){};:'".,<>?«»“”‘’]))'';
      };
      "regex:data" = {
        regex = ''
          (([a-fA-f0-9]{7,128})|(ghp_[0-9a-zA-Z]{36})|([0-9]{4,})|([0-9a-f]{7,40})|(core-[0-9a-z]+-[0-9a-z]+-[0-9a-z]+)|(0x[0-9a-fA-F]+)|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3})|([A-f0-9:]+:+[A-f0-9:]+[A-f0-9]+)|([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,})|([a-z][[:alnum:]-]+:(/{1,3}|[a-z0-9%])|www[:digit:]{0,3}[.])([^[:space:](){}<>]+|\(([^[:space:](){}<>]+|(\([^[:space:](){}<>]+\)))*\)|\[([^]\[[:space:](){}<>]+|(\[[^]\[[:space:](){}<>]+\]))*\])+(\(([^[:space:](){}<>]+|(\([^[:space:](){}<>]+\)))*\)|\[([^]\[[:space:](){}<>]+|(\[[^]\[[:space:](){}<>]+\]))*\]|[^]\[[:space:]`!(){};:'".,<>?«»“”‘’]))'';
      };
      key-bindings = {
        regex-copy = "[data] Control+o";
        show-urls-launch = "Control+u";
      };
      cursor = { style = "block"; };
      mouse = { hide-when-typing = "no"; };
      colors = {
        alpha = 0.6;
        foreground = "D1B88E";
        background = "000000";
        # flash=7f7f00
        # flash-alpha=0.5

        ## Normal/regular colors (color palette 0-7)
        regular0 = "262626"; # gray
        regular1 = "cc0000"; # red
        regular2 = "42B63F"; # green
        regular3 = "DD9400"; # yello
        regular4 = "DD9400"; # yello
        regular5 = "bf78cf"; # purple
        regular6 = "74cd45"; # blue-green
        regular7 = "D1B88E"; # yellow-white

        ## Bright colors (color palette 8-15)
        bright0 = "a79e67"; # gray-green
        bright1 = "ef2929"; # red
        bright2 = "8ae234"; # green
        bright3 = "ead96b"; # yellow
        bright4 = "729fcf"; # blue
        bright5 = "ad7fa8"; # pink
        bright6 = "ead96b"; # yellow
        bright7 = "eeeeec"; # light-yellow
      };
      scrollback = { lines = 999999; };
    };
  };
}
