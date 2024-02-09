{ pkgs, config, ... }:

{


  programs.waybar = with config.colorScheme.palette; {
    enable = true;
    # doesn't work well, starting in autostart hyprland script instead
    # systemd.enable = true;
    # systemd.target = "hyprland-session.target";

    # TODO: very generic color names maybe too generic
    style = ''
    @define-color base00  #${base00};
    @define-color base01 #${base01};
    @define-color base02 #${base02};
    @define-color secondary00 #${base03};
    @define-color secondary01 #${base04};
    @define-color text #${base05};
    @define-color accent00 #${base06};
    @define-color accent01 #${base07};
    @define-color accent02 #${base08};
    @define-color accent03 #${base09};
    @define-color accent04 #${base0A};
    @define-color accent05 #${base0B};
    @define-color accent06 #${base0C};
    @define-color accent07 #${base0D};
    @define-color accent08 #${base0E};
    @define-color accent09 #${base0F};
    ${builtins.readFile ./style.css} 
    '';

    settings = [{
      layer = "top";
      margin-top = 5;
      margin-left = 5;
      margin-right = 5;
      modules-left = ["hyprland/workspaces" "backlight" "pulseaudio"];
      modules-center = ["clock"];
      modules-right =  ["temperature" "cpu" "memory" "battery" "custom/notification" "tray"];
      "wlr/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        all-outputs = false;
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };
      backlight = {
        device = "amd_backlight";
        format = "{percent}% {icon} ";
        format-icons = ["󰃞" "󰃝" "󰃠"];
        on-scroll-up = "swayosd --brightness=raise";
        on-scroll-down = "swayosd --brightness=lower";
      };
      pulseaudio = { 
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon}  {format_source}";
        format-bluetooth-muted = "󰋐 {icon}  {format_source}";
        format-muted = "󰝟 {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "󰏴";
          headset = "󰋎";
          phone = "";
          portable = "";
          car = "";
          default = ["󰕿" "󰖀" "󰕾"];
        };
        on-scroll-up = "swayosd --output-volume=raise";
        on-scroll-down = "swayosd --output-volume=lower";
        on-click = "killall pavucontrol || pavucontrol"; 
      };
      network = {
        format = "{ifname}";
        format-wifi = "{ipaddr} {icon} ";
        format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        format-ethernet = "{ipaddr}/{cidr} 󰈀 ";
        format-disconnected = "󰤮 ";
        tooltip-format = "{ifname} via {gwaddr} 󰈀 ";
        tooltip-format-wifi = "{essid} ({signalStrength}%) {icon} ";
        tooltip-format-ethernet = "{ifname}  ";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
        on-click = "nm-connection-editor";
      };
      clock = {
        format = "{:%a, %d. %b  %H:%M}";
      };
      temperature = {
        critical-threshold = 80;
        format-critical = "{temperatureC}°C ";
        format = "{temperatureC}°C ";
      };
      cpu = {
        interval = 10;
        format = "{usage}%  ";
        states = {
          warning = 25;
          critical = 75;
        };
      };
      memory = {
        interval = 30;
        format = "{percentage}%  ";
      };
      battery = {
        bat = "BAT0";
        states = {
          warning = 35;
          critical = 20;
        };
        format-icons = ["" "" "" "" ""];
        format = "{capacity}% {icon} ";
        format-charging = "{capacity}% {icon}  ";
        tooltip-format = "{timeTo} ({power}W)";
      };
      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };
      tray = {
        icon-size = 21;
        spacing = 10;
      };
    }];
  };
}
