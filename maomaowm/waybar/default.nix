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
  rofiAppGrid = pkgs.writeShellApplication {
    name = "rofi-appgrid";
    runtimeInputs = with pkgs; [ rofi-wayland ];
    text = ''
      rofi \
        -show drun \
        -theme "${config.xdg.configHome}/rofi/launchers/rofi-appgrid/style.rasi"
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
          font-family: Maple Mono NF CN;
          font-size: 22px;
          min-height: 0;
        }

        tooltip {
          background: @mantle;
          opacity: 0.95;
          border: 1px solid @blue;
        }

        tooltip label {
          color: @text;
          font-family: Maple Mono NF CN;
          font-size: 18px;
        }

        #waybar {
          background: transparent;
          color: @text;
          margin: 5px 0 0 0;
        }

        #custom-launcher {
          background-color: @base;
          border-radius: 0.75rem;
          color: @sapphire;
          margin: 5px 0 0 0;
          margin-left: 0.5rem;
          opacity: 0.9;
          padding: 0.25rem 0.75rem;
        }

        #custom-launcher:hover {
          background-color: #242536;
        }

        #tags {
          border-radius: 0.75rem;
          background-color: @base;
          margin: 5px 0 0 0.5rem;
          margin-left: 1rem;
          opacity: 0.9;
        }

        #tags button {
          border-radius: 0.75rem;
          color: @mauve;
          padding: 0.25rem 0.75rem;
        }

        #tags button.active {
          color: @peach;
        }

        #tags button:hover {
          background-color: @mantle;
        }

        #idle_inhibitor {
          border-radius: 0.75rem 0 0 0.75rem;
          color: @flamingo;
        }

        #custom-eyecandy {
          color: @flamingo;
        }

        #clock {
          color: @rosewater;
          font-size: 16px;
        }

        #custom-calendar {
          color: @flamingo;
        }

        #custom-swaync {
          border-radius: 0 0.75rem 0.75rem 0;
          color: @flamingo;
        }

        #idle_inhibitor,
        #custom-eyecandy,
        #clock,
        #custom-calendar,
        #custom-swaync {
          background-color: @base;
          margin: 5px 0 0 0;
          padding: 0.25rem 0.75rem;
          opacity: 0.9;
        }

        #idle_inhibitor:hover,
        #custom-eyecandy:hover,
        #clock:hover,
        #custom-calendar:hover,
        #custom-swaync:hover {
          background-color: #242536;
        }

        #tray {
          margin-right: 1rem;
          border-radius: 0.75rem;
        }

        #tray menu * {
          font-family: Maple Mono NF CN;
          font-size: 18px;
        }

        #tray,
        #wireplumber,
        #pulseaudio.input,
        #bluetooth,
        #network,
        #battery,
        #backlight,
        #cpu,
        #temperature,
        #power-profiles-daemon,
        #custom-session {
          background-color: @base;
          margin: 5px 0 0 0;
          padding: 0.25rem 0.75rem;
          opacity: 0.9;
        }

        #wireplumber:hover,
        #pulseaudio.input:hover,
        #bluetooth:hover,
        #network:hover,
        #battery:hover,
        #backlight:hover,
        #cpu:hover,
        #temperature:hover,
        #power-profiles-daemon:hover,
        #custom-session:hover {
          background-color: #242536;
        }

        #wireplumber {
          color: @mauve;
          border-radius: 0.75rem 0 0 0.75rem;
          margin-left: 1rem;
        }

        #pulseaudio.input {
          border-radius: 0;
          color: @mauve;
        }

        #bluetooth {
          border-radius: 0;
          color: @blue;
        }

        #network {
          border-radius: 0;
          color: @sapphire;
        }

        #battery {
          border-radius: 0;
          color: @green;
        }

        #battery.charging {
          color: @green;
        }

        #battery.warning:not(.charging) {
          color: @red;
        }

        #backlight {
          border-radius: 0;
          color: @yellow;
        }

        #cpu {
          border-radius: 0;
          color: @teal;
        }

        #temperature {
          border-radius: 0;
          color: @peach;
        }

        #temperature.critical {
          color: @red;
        }

        #power-profiles-daemon {
          border-radius: 0 0.75rem 0.75rem 0;
          color: @maroon;
          font-size: 25px;
          margin-right: 1rem;
        }

        #custom-session {
          border-radius: 0.75rem;
          color: @red;
          margin-right: 0.5rem;
        }
      '';
      settings = [{
        exclusive = true;
        output = outputDisplay;
        layer = "bottom";
        position = "top";
        modules-left = [ "custom/launcher" "dwl/tags" ];
        modules-center =
          [ "idle_inhibitor" "clock" "custom/calendar" "custom/swaync" ];
        modules-right = [
          "tray"
          "wireplumber"
          "pulseaudio#input"
          "bluetooth"
          "network"
          "battery"
          "backlight"
          "cpu"
          "temperature"
          "power-profiles-daemon"
          "custom/session"
        ];
        "custom/launcher" = {
          format = "<big>󱄅</big>";
          on-click = "${lib.getExe rofiAppGrid}";
          tooltip-format = "  Applications Menu";
        };
        "dwl/tags" = {
          num-tags = 9;
          hide-unused-tag = true;
        };
        idle_inhibitor = {
          format = "<big>{icon}</big>";
          format-icons = {
            activated = "<span foreground='#f5c2e7'>󰅶</span>";
            deactivated = "󰾪";
          };
          start-activated = false;
          tooltip-format-activated = "󰅶  Caffeination {status}";
          tooltip-format-deactivated = "󰾪  Caffeination {status}";
        };
        clock = {
          actions = {
            on-click-middle = "shift_down";
            on-click-right = "shift_up";
          };
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            on-scroll = 1;
            weeks-pos = "right";
            format = {
              days = "<span color='#cdd6f4'><b>{}</b></span>";
              months = "<span color='#89b4fa'><b>{}</b></span>";
              weeks = "<span color='#74c7ec'><b>󱦰{}</b></span>";
              weekdays = "<span color='#fab387'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b>{}</b></span>";
            };
          };
          format = "<big>{:%H:%M}</big>";
          format-alt = "{:%a, %d %b %R}";
          interval = 60;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };
        "custom/calendar" = {
          format = "<big>󰔠</big>";
          max-length = 2;
          on-click = "${lib.getExe pkgs.gnome-calendar}";
          on-click-middle = "${lib.getExe pkgs.mousam}";
          on-click-right = "${lib.getExe pkgs.gnome-clocks}";
          tooltip-format = ''
            󰸗  Calendar (left-click)
            󰼳  Weather (middle-click)
            󱎫  Clock (right-click)'';
        };
        #https://haseebmajid.dev/posts/2024-03-15-til-how-to-get-swaync-to-play-nice-with-waybar/
        "custom/swaync" = {
          format = "<big>{icon}</big>";
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
          on-click-middle =
            "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd --skip-wait";
          tooltip-format = "󰵚  {} notification(s)";
        };
        tray = {
          icon-size = 22;
          spacing = 12;
        };
        wireplumber = {
          scroll-step = 5;
          format = "<big>{icon}</big>";
          format-alt = "<big>{icon}</big> <small>{volume}󰏰</small>";
          format-muted = "󰖁";
          format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
          max-volume = 100;
          on-click-middle = "${pkgs.avizo}/bin/volumectl -d -u toggle-mute";
          on-click-right = "${lib.getExe pkgs.pwvucontrol}";
          on-scroll-up = "${pkgs.avizo}/bin/volumectl -d -u up 2";
          on-scroll-down = "${pkgs.avizo}/bin/volumectl -d -u down 2";
          tooltip-format = ''
            󰓃  {volume}󰏰
            󰒓  {node_name}'';
        };
        "pulseaudio#input" = {
          format = "<big>{format_source}</big>";
          format-alt =
            "<big>{format_source}</big> <small>{source_volume}󰏰</small>";
          format-source = "󰍬";
          format-source-muted = "󰍭";
          on-click-middle = "${pkgs.avizo}/bin/volumectl -d -m toggle-mute";
          on-click-right = "${lib.getExe pkgs.pwvucontrol}";
          on-scroll-up = "${pkgs.avizo}/bin/volumectl -d -m up 2";
          on-scroll-down = "${pkgs.avizo}/bin/volumectl -d -m down 2";
          tooltip-format = ''
              {source_volume}󰏰
            󰒓  {desc}'';
          ignored-sinks = [ "Easy Effects Sink" "INZONE Buds Analog Stereo" ];
        };
        network = {
          format = "<big>{icon}</big>";
          format-alt =
            " <small>{bandwidthDownBits}</small>  <small>{bandwidthUpBits}</small>";
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
        bluetooth = {
          format = "<big>{icon}</big>";
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
        backlight = {
          device = "intel_backlight";
          format = "<big>{icon}</big>";
          format-alt = "<big>{icon}</big> <small>{percent}󰏰</small>";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
          on-click-middle = "${pkgs.avizo}/bin/lightctl -d set 50";
          on-scroll-up = "${pkgs.avizo}/bin/lightctl -d up 2";
          on-scroll-down = "${pkgs.avizo}/bin/lightctl -d down 2";
          tooltip-format = "󰃠  {percent}󰏰";
        };
        power-profiles-daemon = {
          format = "<big>{icon}</big>";
          format-icons = {
            default = "󱐋";
            performance = "󰤇";
            balanced = "󰗑";
            power-saver = "󰴻";
          };
          tooltip-format = ''
            󱐋  Power profile: {profile}
            󰒓  Driver: {driver}'';
        };
        cpu = {
          interval = 2;
          format = "<big>{icon}</big>";
          format-alt = "<big></big> <small>{usage}󱉸</small>";
          format-icons = [ "󰫃" "󰫄" "󰫅" "󰫆" "󰫇" "󰫈" ];
          on-click-right = "${pkgs.resources}/bin/resources --open-tab-id cpu";
        };
        temperature = {
          hwmon-path = "${hwmonPath}";
          critical-threshold = 90;
          format = "<big>{icon}</big>";
          format-alt = "<big>{icon}</big> <small>{temperatureC}󰔄</small>";
          format-critical = "<big></big> <small>{temperatureC}󰔄</small>";
          format-icons = [ "" "" "" "" "" "" "" "" "" "" ];
          tooltip-format = "󰔐  CPU {temperatureC}󰔄";
        };
        battery = {
          states = {
            good = 80;
            warning = 20;
            critical = 5;
          };
          format = "<big>{icon}</big>";
          format-alt = "<big>{icon}</big> <small>{capacity}󰏰</small>";
          format-charging = "󰂄";
          format-full = "󰁹";
          format-plugged = "󰚥";
          format-icons = [ "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "󱊣  {time} ({capacity}󰏰)";
        };
        "custom/session" = {
          format = "<big>󰐥</big>";
          on-click =
            "${lib.getExe pkgs.wlogout} --buttons-per-row 5 ${wlogoutMargins}";
          tooltip-format = "󰐥  Session Menu";
        };
      }];
    };
  };
}
