{ config, inputs, lib, pkgs, username, ... }: {
  imports = [
    inputs.maomaowm.hmModules.maomaowm
    ./hyprlock
    ./swaync
    ./waybar
    ./wlogout
  ];
  xdg.configFile."maomao/screenshot.sh" = { source = ./screenshot.sh; };
  home = {
    # file.".config/maomao/screenshot.sh" = {
    #   text = builtins.readFile ./screenshot.sh;
    # };
    packages = with pkgs; [
      cliphist
      grim
      lswt
      satty
      slurp
      swww
      xorg.xev
      xorg.xprop
    ];
  };
  services.flameshot = {
    enable = false;
    package = (pkgs.flameshot.overrideAttrs
      (old: { src = inputs.flameshot-git; })).override {
        enableMonochromeIcon = true;
        enableWlrSupport = true;
      };
    settings = {
      General = {
        allowMultipleGuiInstances = false;
        copyOnDoubleClick = true;
        disabledTrayIcon = true;
        filenamePattern = "%F_%H-%M";
        saveAsFileExtension = ".png";
        savePath = "/home/${username}/Pictures/Screenshots";
        showDesktopNotification = true;
        showStartupLaunchMessage = false;
      };
    };
  };
  wayland.windowManager.maomaowm = {
    enable = true;
    settings = ''
      # Animation Configuration
      animations=1
      animation_type_open=zoom
      animation_type_close=slide
      animation_fade_in=1
      zoom_initial_ratio=0.5
      fadein_begin_opacity=0.5
      fadeout_begin_opacity=0.8
      animation_duration_move=500
      animation_duration_open=400
      animation_duration_tag=350
      animation_duration_close=800
      animation_curve_open=0.46,1.0,0.29,1
      animation_curve_move=0.46,1.0,0.29,1
      animation_curve_tag=0.46,1.0,0.29,1
      animation_curve_close=0.08,0.92,0,1

      # Scroller Layout Setting
      scroller_structs=20
      scroller_default_proportion=0.8
      scroller_default_proportion_single=1.0
      scroller_focus_center=0
      scroller_prefer_center=1
      scroller_proportion_preset=0.5,0.8,1.0

      # Master-Stack Layout Setting (tile,spiral,dwindle)
      new_is_master=1
      default_mfact=0.55
      default_nmaster=1
      smartgaps=0
      # only work in spiral and dwindlw
      default_smfact=0.5

      # Overview Setting
      hotarea_size=10
      enable_hotarea=1
      ov_tab_mode=0
      overviewgappi=5
      overviewgappo=30

      # Misc
      xwayland_persistence=1
      syncobj_enable=1
      no_border_when_single=0
      axis_bind_apply_timeout=100
      focus_on_activate=1
      bypass_surface_visibility=0
      sloppyfocus=1
      warpcursor=1
      focus_cross_monitor=0
      focus_cross_tag=0
      circle_layout=spiral,scroller
      enable_floating_snap=1
      snap_distance=50
      cursor_size=24
      cursor_theme=Bibata-Modern-Ice
      cursor_hide_timeout=0
      drag_tile_to_tile=1
      single_scratchpad = 1

      # keyboard
      repeat_rate=25
      repeat_delay=600
      numlockon=0
      xkb_rules_layout=us

      # Trackpad
      tap_to_click=1
      tap_and_drag=1
      drag_lock=1
      mouse_natural_scrolling=0
      trackpad_natural_scrolling=0
      disable_while_typing=1
      left_handed=0
      middle_button_emulation=0
      swipe_min_threshold=20
      accel_profile=2
      accel_speed=0.0

      # Appearance
      gappih=5
      gappiv=5
      gappoh=10
      gappov=10
      borderpx=4
      rootcolor=0x323232ff
      bordercolor=0x444444ff
      focuscolor=0xad741fff
      maxmizescreencolor=0x89aa61ff
      urgentcolor=0xad401fff
      scratchpadcolor=0x516c93ff
      globalcolor=0xb153a7ff

      # layout circle limit
      # if not set, it will circle all layout
      # circle_layout=spiral,scroller

      # tags rule
      # layout support: tile,scroller,grid,monocle,spiral,dwindle
      tagrule=id:1,layout_name:scroller
      tagrule=id:2,layout_name:scroller
      tagrule=id:3,layout_name:scroller
      tagrule=id:4,layout_name:scroller
      tagrule=id:5,layout_name:scroller
      tagrule=id:6,layout_name:scroller
      tagrule=id:7,layout_name:scroller
      tagrule=id:8,layout_name:scroller
      tagrule=id:9,layout_name:scroller

      # Window Rules
      # appid: type-string if match it or title, the rule match
      # title: type-string if match it or appid, the rule match
      # tags: type-num(1-9)
      # isfloating: type-num(0 or 1)
      # isfullscreen: type-num(0 or 1)
      # scroller_proportion: type-float(0.1-1.0)
      # animation_type_open : type-string(zoom,slide,none)
      # animation_type_close : type-string(zoom,slide)
      # isnoborder : type-num(0 or 1)
      # monitor  : type-int(0-99999)
      # width : type-num(0-9999)
      # height : type-num(0-9999)
      # isterm : type-num (0 or 1) -- when new window open, will replace it, and will restore after the sub window exit
      # nnoswallow : type-num(0 or 1) -- if enable, this window wll not replace isterm window when it was open by isterm window
      # globalkeybinding: type-string(for example-- alt-l or alt+super-l)

      # example
      # windowrule=isfloating:1,appid:yesplaymusic
      # windowrule=width:1500,appid:yesplaymusic
      # windowrule=height:900,appid:yesplaymusic
      # windowrule=isfloating:1,title:qxdrag
      # windowrule=isfloating:1,appid:Rofi
      # windowrule=isfloating:1,appid:wofi
      # windowrule=isnoborder:1,appid:wofi
      # windowrule=animation_type_open:zoom,appid:wofi
      # windowrule=globalkeybinding:ctrl+alt-o,appid:com.obsproject.Studio
      # windowrule=globalkeybinding:ctrl+alt-n,appid:com.obsproject.Studio

      # open in specific tag
      windowrule=tags:5,appid:firefox
      windowrule=tags:7,appid:QQ
      windowrule=tags:7,appid:Element
      # windowrule=tags:7,appid:
      windowrule=tags:5,appid:ncmpcpp

      windowrule=width:1500,title:Open Files
      windowrule=height:900,title:Open Files
      windowrule=width:1500,title:Enter name of file to save to…
      windowrule=width:900,title:Enter name of file to save to…

      windowrule=isfloating:1,title:图片查看器
      windowrule=isfloating:1,title:图片查看
      windowrule=isfloating:1,title:选择文件
      windowrule=isfloating:1,title:打开文件
      windowrule=isfloating:1,appid:polkit-gnome-authentication-agent-1

      windowrule=animation_type_open:zoom,title:图片查看器
      windowrule=animation_type_open:zoom,title:图片查看
      windowrule=animation_type_open:zoom,title:选择文件
      windowrule=animation_type_open:zoom,title:打开文件

      windowrule=isfullscreen:1,appid:flameshot
      windowrule=noswallow:1,appid:flameshot
      windowrule=animation_type_open:none,appid:flameshot

      # Monitor Rules
      # name|mfact|nmaster|scale|layout|(rotate or reflect)|x|y
      # rotate or reflect:
      # 0:no transform
      # 1:90 degrees counter-clockwise
      # 2:180 degrees counter-clockwise
      # 3:270 degrees counter-clockwise
      # 4:180 degree flip around a vertical axis
      # 5:flip and rotate 90 degrees counter-clockwise
      # 6:flip and rotate 180 degrees counter-clockwise
      # 7:flip and rotate 270 degrees counter-clockwise

      # example
      # monitorrule=eDP-1,0.55,1,tile,0,1,0,0
      # monitorrule=HDMI-A-1,0.55,1,tile,0,1,1920,0

      # Key Bindings
      # The mod key is not case sensitive,
      # but the second key is case sensitive,
      # if you use shift as one of the mod keys,
      # remember to use uppercase keys

      # reload config
      bind=SUPER+SHIFT,R,reload_config

      # menu and terminal
      bind=SUPER,d,spawn,rofi -show drun -theme "${config.xdg.configHome}/rofi/launchers/rofi-appgrid/style.rasi"
      bind=SUPER,Return,spawn,foot

      bind=SUPER,0,spawn_on_empty,qq,7
      bind=SUPER,c,spawn_on_empty,firefox,5

      bind=SUPER,l,spawn,hyprlock
      bind=CTRL+ALT,a,spawn,~/.config/maomao/screenshot.sh 1 5 2

      bind=SUPER,s,toggle_scratchpad

      # exit
      bind=SUPER+SHIFT,Q,quit
      bind=SUPER,q,killclient,

      # switch window focus
      bind=SUPER,Tab,focusstack,next
      bind=SUPER,Left,focusdir,left
      bind=SUPER,Right,focusdir,right
      bind=SUPER,Up,focusdir,up
      bind=SUPER,Down,focusdir,down

      # swap window
      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down
      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right

      # switch window status
      bind=SUPER,g,toggleglobal,
      bind=ALT,Tab,toggleoverview,
      bind=ALT,backslash,togglefloating,
      bind=ALT,a,togglemaxmizescreen,
      bind=ALT,f,togglefullscreen,
      bind=SUPER,i,minized,
      bind=SUPER+SHIFT,I,restore_minized
      bind=ALT,z,toggle_scratchpad

      # scroller layout
      bind=SUPER,f,set_proportion,1.0
      bind=SUPER+SHIFT,F,set_proportion,0.8
      bind=ALT,x,switch_proportion_preset,

      # tile layout
      bind=SUPER,e,incnmaster,1
      bind=SUPER,t,incnmaster,-1
      bind=ALT+CTRL,Left,setmfact,-0.01
      bind=ALT+CTRL,Right,setmfact,+0.01
      bind=ALT+CTRL,Up,setsmfact,-0.01
      bind=ALT+CTRL,Down,setsmfact,+0.01
      bind=ALT,s,zoom,

      # switch layout
      bind=CTRL+SUPER,i,setlayout,tile
      bind=CTRL+SUPER,l,setlayout,scroller
      bind=SUPER,n,switch_layout

      # tag switch
      # bind=SUPER,Left,viewtoleft,
      # bind=CTRL,Left,viewtoleft_have_client,
      # bind=SUPER,Right,viewtoright,
      # bind=CTRL,Right,viewtoright_have_client,
      # bind=CTRL+SUPER,Left,tagtoleft,
      # bind=CTRL+SUPER,Right,tagtoright,

      # normal num key  is (1-9)
      # right-side keyboard num keys is (KP_1-KP_9)
      bind=SUPER,1,view,1
      bind=SUPER,2,view,2
      bind=SUPER,3,view,3
      bind=SUPER,4,view,4
      bind=SUPER,c,view,5
      bind=SUPER,m,view,6
      bind=SUPER,0,view,7
      bind=SUPER,8,view,8
      bind=SUPER,9,view,9

      bind=Super+SHIFT,exclam,tag,1
      bind=Super+SHIFT,at,tag,2
      bind=Super+SHIFT,numbersign,tag,3
      bind=Super+SHIFT,dollar,tag,4
      bind=Super+SHIFT,percent,tag,5
      bind=Super+SHIFT,asciicircum,tag,6
      bind=Super+SHIFT,ampersand,tag,7
      bind=Super+SHIFT,asterisk,tag,8
      bind=Super+SHIFT,parenleft,tag,9

      # monitor switch
      bind=SUPER,bracketleft,focusmon,left
      bind=SUPER,bracketright,focusmon,right
      bind=SUPER+CTRL,bracketleft,tagmon,left
      bind=SUPER+CTRL,bracketright,tagmon,right

      # gaps
      bind=ALT+SHIFT,X,incgaps,1
      bind=ALT+SHIFT,Z,incgaps,-1
      bind=ALT+SHIFT,R,togglegaps

      # Mouse Button Bindings
      # NONE mode key only work in ov mode
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=NONE,btn_middle,togglemaxmizescreen,0
      mousebind=SUPER,btn_right,moveresize,curresize
      mousebind=NONE,btn_left,toggleoverview,-1
      mousebind=NONE,btn_right,killclient,0

      # Axis Bindings
      axisbind=SUPER,UP,viewtoleft_have_client
      axisbind=SUPER,DOWN,viewtoright_have_client
    '';
    autostart_sh = builtins.readFile (pkgs.replaceVars ./autostart.sh {
      authAgent =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      wlclipboard = "${pkgs.wl-clipboard}";
      wlclippersist = "${lib.getExe pkgs.wl-clip-persist}";
      swwwrandomize =
        pkgs.writeText "a.sh" (builtins.readFile ./swww-randomize.sh);
      swww = "${pkgs.swww}";
    });
  };
}
