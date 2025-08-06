{ config, hostname, lib, pkgs, ... }:
let
  wlogoutMargins = if hostname == "vader" then
    "--margin-top 960 --margin-bottom 960"
  else if hostname == "phasma" then
    "--margin-left 540 --margin-right 540"
  else
    "";
  outputDisplay = if (hostname != "laptop") then "DP-1" else "eDP-1";
  hwmonPath = if (hostname == "laptop") then
    "/sys/class/hwmon/hwmon4/temp1_input"
  else if hostname == "tanis" then
    "/sys/class/hwmon/hwmon3/temp1_input"
  else
    "/sys/class/hwmon/hwmon0/temp1_input";
  bluetoothToggle = pkgs.writeShellApplication {
    name = "bluetooth-toggle";
    runtimeInputs = with pkgs; [ bluez gawk gnugrep ];
    text = ''
      HOSTNAME=$(hostname -s)
      state=$(bluetoothctl show | grep 'Powered:' | awk '{ print $2 }')
      if [[ $state == 'yes' ]]; then
        bluetoothctl discoverable off
        bluetoothctl power off
      else
        bluetoothctl power on
        bluetoothctl discoverable on
        if [ "$HOSTNAME" == "phasma" ]; then
            bluetoothctl connect E4:50:EB:7D:86:22
        fi
      fi
    '';
  };
in {
  home = {
    file."${config.xdg.configHome}/rofi/launchers/rofi-appgrid/style.rasi".source =
      ./style.rasi;
  };
  programs = {
    waybar = {
      enable = true;
      style = ''
        * {
            font-family: Maple Mono NF CN, Arial, sans-serif;
            font-size: 20px;
            font-weight: bolder;
        }

        tooltip {
            background: #3C3A38;
            border: 2px solid #85796F;
            border-radius: 10px;
        }

        tooltip label {
          color: #EBDBB2;
        }

        window#waybar {
            background-color: transparent;
        }

        #tags{
            background-color: transparent;
            margin-top: 5px;
            margin-bottom: 12px;
            margin-right: 1px;
            margin-left: 10px;
        }

        #tags button{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -3px 5px 5px;
            background-color: #5d5d5b;
            padding-bottom: 1px;
            padding-top: 5px;
            margin-right: 8px;
            padding-right: 11px;
            padding-left: 7px;
            background-size: 300% 300%;
            font-weight: bolder;
            color: 	#d9baff ;
            border: none;
            border-bottom: 4px solid #3d3c3c;
            border-radius: 5px;
        }

        #tags button.occupied{
            box-shadow: rgba(0, 0, 0, 0.5) 0px -3px 5px 5px;
            background-color: #fff;
            padding-bottom: 1px;
            padding-top: 5px;
            margin-right: 8px;
            padding-right: 7px;
            padding-left: 7px;
            background-size: 300% 300%;
            font-weight: bolder;
            color: 	#7f5daa ;
            border: none;
            border-bottom: 4px solid #d6cdcd;
            border-radius: 5px;
        }

        #tags button.focused{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -3px 5px 5px;
            background-color: rgb(180, 131, 208);
            padding-bottom: 1px;
            padding-top: 5px;
            margin-right: 8px;
            padding-right: 10px;
            padding-left: 10px;
            background-size: 300% 300%;
            font-weight: bolder;
            color: 	#fff;
            border: none;
            border-bottom: 4px solid rgb(143, 102, 168);
            border-radius: 5px;
        }

        #tags button.urgent{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -3px 5px 5px;
            padding-bottom: 1px;
            padding-top: 1px;
            margin-right: 8px;
            padding-right: 7px;
            padding-left: 7px;
            padding-bottom: 3px;
            background: rgb(171, 101, 101);
            /* background: linear-gradient(45deg, rgba(202,158,230,1) 0%, rgba(245,194,231,1) 43%, rgba(180,190,254,1) 80%, rgba(137,180,250,1) 100%);  */
            background-size: 300% 300%;
            /* animation: gradient 10s ease infinite; */
            color: #fff;
            border: none;
            border-bottom: 4px solid rgb(105, 57, 57);
            border-radius: 5px;
        }

        #taskbar{
            background-color: transparent;
            margin-top: 5px;
            margin-bottom: 12px;
            margin-right: 1px;
            margin-left: 1px;
        }

        #taskbar button{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            /* text-shadow: 0 0 2px rgba(0, 0, 0, 0.8); */
            background-color: rgb(237, 196, 147);
            margin-right: 8px;
            padding-top: 2px;
            padding-bottom: 1px;
            padding-right: 5px;
            padding-left: 5px;
            font-weight: bolder;
            color: 	#ededed;
            border: none;
            border-bottom: 4px solid rgb(193, 146, 103);
            border-radius: 5px;
        }

        #taskbar button.minimized{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            background-color: rgb(146, 140, 151);
            margin-right: 8px;
            padding-top: 2px;
            padding-bottom: 1px;
            padding-right: 5px;
            padding-left: 5px;
            font-weight: bolder;
            color: 	#cba6f7;
            border: none;
            border-bottom: 4px solid rgb(98, 97, 99);
            border-radius: 5px;
        }

        #taskbar button.urgent{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            background-color: rgb(238, 92, 92);
            margin-right: 8px;
            padding-top: 2px;
            padding-bottom: 1px;
            padding-right: 5px;
            padding-left: 5px;
            font-weight: bolder;
            color: 	#cba6f7;
            border: none;
            border-bottom: 4px solid rgb(183, 63, 63);
            border-radius: 5px;
        }

        #taskbar button.active{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            background-color: rgb(186, 238, 225);
            margin-right: 8px;
            padding-top: 2px;
            padding-bottom: 1px;
            padding-right: 5px;
            padding-left: 5px;
            font-weight: bolder;
            color: 	#cba6f7;
            border: none;
            border-bottom: 4px solid rgb(131, 184, 171);
            border-radius: 5px;
        }

        #window{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            /* text-shadow: 0 0 2px rgba(0, 0, 0, 0.8); */
            background-color: rgb(237, 196, 147);
            margin-top: 5px;
            margin-bottom: 12px;
            margin-right: 5px;
            margin-left: 1px;
            padding-top: 1px;
            padding-bottom: 1px;
            padding-right: 5px;
            padding-left: 5px;
            font-weight: normal;
            color: 	rgb(63, 37, 5);
            border: none;
            border-bottom: 4px solid rgb(193, 146, 103);
            border-radius: 5px;
        }


        #custom-notification {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -3px 5px 5px;
            background-color: #cb7cc6;
            padding-bottom: 1px;
            padding-top: 1px;
            padding-right: 8px;
            padding-left: 5px;
            background-size: 300% 300%;
            font-weight: bolder;
            color: 	rgb(244, 240, 233);
            border: none;
            border-bottom: 4px solid #904e8b;
            border-radius: 5px;
            margin-top: 5px;
            margin-bottom: 12px;
            margin-right: 1px;
            margin-left: 1px;
        }

        @keyframes gradient {
         	0% {
        		background-position: 0% 50%;
         	}
         	50% {
        		background-position: 100% 50%;
         	}
         	100% {
        		background-position: 0% 50%;
         	}
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #wireplumber,
        #custom-media,
        #tray,
        #mode,
        #idle_inhibitor,
        #custom-expand,
        #custom-cycle_wall,
        #custom-ss,
        #custom-dynamic_pill,
        #mpd {
            padding: 0 10px;
            border-radius: 5px;
            background-color: #cdd6f4;
            color: #516079;
            box-shadow: rgba(0, 0, 0, 0.116) 2px 2px 5px 2px;
            margin-top: 5px;
            margin-bottom: 12px;
            margin-right: 1px;
        }

        #custom-dynamic_pill.low{
            background: rgb(148,226,213);
            background: linear-gradient(52deg, rgba(148,226,213,1) 0%, rgba(137,220,235,1) 19%, rgba(116,199,236,1) 43%, rgba(137,180,250,1) 56%, rgba(180,190,254,1) 80%, rgba(186,187,241,1) 100%);
            background-size: 300% 300%;
            /* text-shadow: 0 0 5px rgba(0, 0, 0, 0.377); */
            animation: gradient 15s ease infinite;
            font-weight: bolder;
            color: #fff;
        }

        #custom-dynamic_pill.normal{
            background: rgb(166,209,137);
            background: linear-gradient(52deg, rgba(166,209,137,1) 0%, rgba(166,227,161,1) 26%, rgba(148,226,213,1) 65%, rgba(129,200,190,1) 100%);
            background-size: 300% 300%;
            animation: gradient 15s ease infinite;
            /* text-shadow: 0 0 5px rgba(0, 0, 0, 0.377); */
            font-weight: bolder;
            color: #fff;
        }

        #custom-dynamic_pill.critical{
            background: rgb(235,160,172);
            background: linear-gradient(52deg, rgba(235,160,172,1) 0%, rgba(243,139,168,1) 30%, rgba(231,130,132,1) 48%, rgba(250,179,135,1) 77%, rgba(249,226,175,1) 100%);
            background-size: 300% 300%;
            animation: gradient 15s ease infinite;
            /* text-shadow: 0 0 5px rgba(0, 0, 0, 0.377); */
            font-weight: bolder;
            color: #fff;
        }

        #custom-dynamic_pill.playing{
            background: rgb(249,226,175);
            background: linear-gradient(45deg, rgba(249,226,175,1) 0%, rgba(245,194,231,1) 20%, rgba(180,190,254,1) 100%);
            background-size: 300% 300%;
            animation: gradient 15s ease infinite;
            /* text-shadow: 0 0 5px rgba(0, 0, 0, 0.377); */
            font-weight: 900;
            color: #fff ;
        }

        #custom-dynamic_pill.paused{
            background: #fff;
            font-weight: bolder;
            color: #b4befe;
        }

        #custom-ss{
            background: #fff;
            color: rgba(203,166,247,1);
            font-weight: bolder;
            padding: 5px;
            padding-left: 20px;
            padding-right: 20px;
            border-radius: 5px;
        }

        #custom-cycle_wall{
            background: rgb(245,194,231);
            /* background: linear-gradient(45deg, rgba(245,194,231,1) 0%, rgba(203,166,247,1) 0%, rgba(243,139,168,1) 13%, rgba(235,160,172,1) 26%, rgba(250,179,135,1) 34%, rgba(249,226,175,1) 49%, rgba(166,227,161,1) 65%, rgba(148,226,213,1) 77%, rgba(137,220,235,1) 82%, rgba(116,199,236,1) 88%, rgba(137,180,250,1) 95%);  */
            color: #fff;
            background-size: 500% 500%;
            /* animation: gradient 7s linear infinite; */
            font-weight:  bolder;
            padding: 5px;
            border-radius: 5px;
        }

        #clock {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            background: rgb(179, 42, 142);
            /* background: linear-gradient(45deg, rgb(99, 6, 74) 0%, rgba(203,166,247,1) 64%, rgba(202,158,230,1) 100%);  */
            margin-left: 1px;
            margin-right: 1px;
            min-width: 50px;
            color: #f8e1b7 ;
            background-size: 300% 300%;
            /* animation: gradient 20s ease infinite; */
            font-size: 20px;
            padding-top: 5px;
            padding-bottom: 3px;
            padding-right: 15px;
            font-weight: bolder;
            padding-left: 15px;
            border: none;
            border-bottom: 4px solid rgb(155, 32, 122);
            border-radius: 5px;
        }

        #battery.charging, #battery.plugged {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            padding-top: 5px;
            padding-bottom: 3px;
            min-width: 70px;
            color: #bdf8da;
            background: #495026;
            margin-right: 10px;
            border: none;
            border-bottom: 4px solid #3a401d;
            border-radius: 5px;
        }

        #battery {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            background-color: #07683e;
            color:#eae4d0;
            font-weight: bolder;
            font-size: 20px;
            padding-top: 3px;
            padding-bottom: 3px;
            padding-left: 15px;
            padding-right: 15px;
            margin-right: 10px;
            border: none;
            border-bottom: 4px solid #297f5a;
            border-radius: 5px;
        }

        @keyframes blink {
            to {
                background-color: #f9e2af;
                color:#96804e;
            }
        }

        #battery.critical:not(.charging) {
            background-color: #f38ba8;
            color:#bf5673;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #cpu {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            min-width: 80px;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 5px;
            padding-bottom: 1px;
            background: rgb(39, 154, 207);
            /* background: linear-gradient(52deg, rgba(180,190,254,1) 0%, rgba(137,220,235,1) 32%, rgba(137,180,250,1) 72%, rgba(166,227,161,1) 100%);  */
            background-size: 300% 300%;
            /* animation: gradient 20s ease infinite; */
            /* text-shadow: 0 10 5px rgba(0, 0, 0, 0.8); */
            /* background-color: #b4befe; */
            color: 	#edebe6;
            font-weight: bolder;
            border: none;
            border-bottom: 4px solid rgb(58, 125, 156);
            border-radius: 5px;
        }

        #memory {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            min-width: 60px;
            background-color: #cba6f7;
            color: 	#55406e;
            font-weight: bolder;
            border: none;
            border-bottom: 4px solid #9172b6;
            border-radius: 5px;
        }

        #disk {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 1px;
            background-color: #cca45a;
            color: #572e05;
        }

        #backlight {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            font-weight: bolder;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            color: #090427;
            min-width: 40px;
            background-color: #c3cac2;
            border: none;
            border-bottom: 4px solid #8a9488;
            border-radius: 5px;
        }

        #network{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            font-weight: bolder;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            color:#000;
        }

        #network.disabled{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            background-color: #45475a;
        }

        #network.disconnected{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            background: rgb(243,139,168);
            /* background: linear-gradient(45deg, rgba(243,139,168,1) 0%, rgba(250,179,135,1) 100%);  */
            color: #fff;
            font-weight: bolder;
            padding-right: 11px;
            border: none;
            border-bottom: 4px solid rgb(213, 115, 142);
            border-radius: 5px;
        }

        #network.linked, #network.wifi{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            background-color: #a6e3a1;
            border: none;
            border-bottom: 4px solid #79b574;
            border-radius: 5px;
        }

        #network.ethernet{
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            background-color: #a6e3a1;
            border: none;
            border-bottom: 4px solid #79b574;
            border-radius: 5px;
        }

        #wireplumber {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            font-weight: bolder;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 5px;
            padding-bottom: 3px;
            min-width: 40px;
            background-color: #fab387;
            color: #734a31;
            border: none;
            border-bottom: 4px solid #b87c57;
            border-radius: 5px;
        }

        #wireplumber.muted {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            background-color: #9f7154;
        }

        #custom-media {
            margin-right: 1px;
            margin-left: 1px;
            color: #66cc99;
        }

        #custom-media.custom-spotify {
            margin-right: 1px;
            margin-left: 1px;
            background-color: #66cc99;
        }

        #custom-media.custom-vlc {
            margin-right: 1px;
            margin-left: 1px;
            background-color: #ffa000;
        }

        #temperature {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            font-weight: bolder;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            background-color: #f9e2af;
            color:#96804e;
        }

        #temperature.critical {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            font-weight: bolder;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 5px;
            padding-bottom: 1px;
            background-color: #ce91a0;
            color:#50393f;
            border: none;
            border-bottom: 4px solid #a26a79;
            border-radius: 5px;
        }

        #tray {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 3px;
            padding-top: 3px;
            padding-bottom: 3px;
            background-color: #96d5dd;
            border: none;
            border-bottom: 4px solid #66a1a9;
            border-radius: 5px;
        }

        #tray > .passive {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
            box-shadow: rgba(0, 0, 0, 0.5) 0 -6px 3px 1px;
            margin-right: 1px;
            margin-left: 1px;
            padding-top: 3px;
            padding-bottom: 3px;
            -gtk-icon-effect: highlight;
            background-color: #eb4d4b;
        }

        #idle_inhibitor {
            margin-right: 1px;
            margin-left: 1px;
            background-color: #2d3436;
        }

        #idle_inhibitor.activated {
            margin-right: 1px;
            margin-left: 1px;
            background-color: #ecf0f1;
            color: #2d3436;
        }

        #mpd {
            background-color: #66cc99;
            color: #2a5c45;
        }

        #mpd.disconnected {
            background-color: #f53c3c;
        }

        #mpd.stopped {
            background-color: #90b1b1;
        }

        #mpd.paused {
            background-color: #51a37a;
        }

        #language {
            background: #00b093;
            color: #740864;
            padding: 0 5px;
            margin: 0 5px;
            min-width: 16px;
        }

        #keyboard-state {
            background: #97e1ad;
            color: #000000;
            padding: 0 0px;
            margin: 0 5px;
            min-width: 16px;
        }

        #keyboard-state > label {
            padding: 0 5px;
        }

        #keyboard-state > label.locked {
            background: rgba(0, 0, 0, 0.2);
        }
      '';
      settings = [{
        exclusive = true;
        output = outputDisplay;
        layer = "bottom";
        position = "top";
        height = 40;
        spacing = 3;
        margin-bottom = -15;
        modules-left = [ "dwl/tags" "wlr/taskbar" "dwl/window" ];
        modules-right = [
          "custom/notification"
          "tray"
          "network"
          "cpu"
          "temperature"
          "memory"
          "clock"
          "wireplumber"
          "backlight"
          "battery"
        ];
        backlight = {
          device = "intel_backlight";
          format = "{icon}";
          format-alt = "{icon} {percent}󰏰";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
          on-click-middle = "${pkgs.avizo}/bin/lightctl -d set 50";
          on-scroll-up = "${pkgs.avizo}/bin/lightctl -d up 2";
          on-scroll-down = "${pkgs.avizo}/bin/lightctl -d down 2";
          tooltip-format = "󰃠  {percent}󰏰";
        };
        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 10;
          };
          format = "{icon}";
          format-alt = "{icon} {capacity}󰏰";
          format-charging = "󰂄";
          format-full = "󰁹";
          format-plugged = "󰚥";
          format-icons = [ "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "󱊣 {time} ({capacity}󰏰)";
        };
        bluetooth = {
          format = "{icon}";
          format-connected = "󰂱";
          format-disabled = "󰂲";
          format-on = "󰂯";
          format-off = "󰂲";
          on-click-middle = "${lib.getExe bluetoothToggle}";
          on-click-right = "${pkgs.blueberry}/bin/blueberry";
          tooltip-format = ''
              {controller_alias}	󰿀  {controller_address}
            󰂴  {num_connections} connected'';
          tooltip-format-connected = ''
              {controller_alias}	󰿀  {controller_address}
            󰂴  {num_connections} connected
            {device_enumerate}'';
          tooltip-format-disabled = ''
            󰂲  {controller_alias}	󰿀  {controller_address}
            󰂳  {status}'';
          tooltip-format-enumerate-connected =
            "󰂱  {device_alias}	󰿀  {device_address}";
          tooltip-format-enumerate-connected-battery =
            "󰂱  {device_alias}	󰿀  {device_address} (󰥉  {device_battery_percentage}󰏰)";
          tooltip-format-off = ''
            󰂲  {controller_alias}	󰿀  {controller_address}
            󰂳  {status}'';
        };
        clock = {
          format = "{:%H:%M} ";
          format-alt = "{:%A, %b %d} ";
          tooltip-format = "{:%Y}";
          on-click-right = "${lib.getExe pkgs.gnome-calendar}";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "${lib.getExe pkgs.gnome-calendar}";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
        cpu = {
          interval = 2;
          format = "{load}󰏰 ";
          on-click-right = "${lib.getExe pkgs.gnome-system-monitor}";
          on-click = "nwg-drawer -ovl";
        };
        #https://haseebmajid.dev/posts/2024-03-15-til-how-to-get-swaync-to-play-nice-with-waybar/
        "custom/notification" = {
          format = "{icon}";
          format-icons = {
            none = "";
            notification = "<span foreground='#f5c2e7'>󱅫</span>";
            dnd-none = "󰂠";
            dnd-notification = "󱅫";
            inhibited-none = "";
            inhibited-notification = "<span foreground='#f5c2e7'>󰅸</span>";
            dnd-inhibited-none = "󰪓";
            dnd-inhibited-notification = "󰅸";
          };
          max-length = 3;
          return-type = "json";
          escape = true;
          exec-if = "which ${pkgs.swaynotificationcenter}/bin/swaync-client";
          exec =
            "${pkgs.swaynotificationcenter}/bin/swaync-client --subscribe-waybar";
          on-click =
            "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel --skip-wait";
          on-click-right =
            "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd --skip-wait";
          tooltip-format = "󰵚  {} notification(s)";
        };
        "dwl/tags" = { tag-labels = [ "" "" "" "" "󰈹" "󰎄" "󰘅" "" "" ]; };
        "dwl/window" = {
          "format" = "{title}";
          "max-length" = 50;
          "rewrite" = {
            "(.*)Mozilla Firefox" = "󰈹 $1";
            "(.*)nvim" = " $1";
            "(.*)fish" = " [$1]";
          };
        };
        keyboard-state = {
          interval = 1;
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        memory = {
          interval = 2;
          format = "{}󰏰 󰍛";
          # on-click = "GDK_BACKEND=x11 nemo";
          on-click-right =
            "cliphist list | rofi -dmenu -normal-window | cliphist decode | wl-copy";
          # "on-click-right":"clipman pick -t wofi"
        };
        network = {
          format = "{icon}";
          format-alt = " {bandwidthDownBits}  {bandwidthUpBits}";
          format-ethernet = "󰈀";
          format-disconnected = "󱚵";
          format-linked = "";
          format-wifi = "󰖩";
          interval = 2;
          on-click-right =
            "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          tooltip-format = ''
              {ifname}
            󰩠  {ipaddr} via {gwaddr}
              {bandwidthDownBits}	  {bandwidthUpBits}'';
          tooltip-format-wifi = ''
            󱛁  {essid}
            󰒢  {signalStrength}󰏰
            󰩠  {ipaddr} via {gwaddr}
              {bandwidthDownBits}	  {bandwidthUpBits}'';
          tooltip-format-ethernet = ''
            󰈀  {ifname}
            󰩠  {ipaddr} via {gwaddr})
              {bandwidthDownBits}	  {bandwidthUpBits}'';
          tooltip-format-disconnected = "󱚵  disconnected";
        };
        temperature = {
          hwmon-path = "${hwmonPath}";
          critical-threshold = 10;
          format = "{icon}";
          format-alt = "{icon} {temperatureC}󰔄";
          format-critical = "{temperatureC}󰔄";
          format-icons = [ "" "" "" "" "" "" "" "" "" "" ];
          tooltip-format = "󰔐  CPU {temperatureC}󰔄";
        };
        tray = {
          # icons = {
          #   "blueman" = "bluetooth";
          #   "TelegramDesktop" =
          #     "$HOME/.local/share/icons/hicolor/16x16/apps/telegram.png";
          # };
          icon-size = 21;
          spacing = 10;
        };
        wireplumber = {
          format = "{icon}";
          format-alt = "{volume}󰏰 {icon}";
          format-muted = "{volume}󰏰 {icon}";
          format-icons = [ "󰕿" "󰖀" "󰕾" ];
          max-volume = 100;
          on-click-middle = "${lib.getExe pkgs.pwvucontrol}";
          on-click-right =
            "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up =
            "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+";
          on-scroll-down =
            "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-";
          scroll-step = 5;
          tooltip-format = ''
            󰓃  {volume}󰏰
            󰒓  {node_name}'';
        };
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 24;
          all-outputs = false;
          tooltip-format = "{title}";
          markup = true;
          on-click = "activate";
          on-click-right = "close";
          ignore-list = [ "Rofi" "wofi" ];
        };
      }];
      systemd = {
        enable = true;
        target = "mango-session.target";
      };
    };
  };
}
