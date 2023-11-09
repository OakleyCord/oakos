{ pkgs, config, ... }:

{


  programs.waybar = with config.colorScheme.colors; {
    enable = true;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";

    # temp use catpuccin color names for compat
    style = ''
    @define-color base  #${base00};
    @define-color mantle #${base01};
    @define-color surface0 #${base02};
    @define-color surface1 #${base03};
    @define-color surface2 #${base04};
    @define-color text #${base05};
    @define-color rosewater #${base06};
    @define-color lavender #${base07};
    @define-color red #${base08};
    @define-color peach #${base09};
    @define-color yellow #${base0A};
    @define-color green #${base0B};
    @define-color teal #${base0C};
    @define-color blue #${base0D};
    @define-color mauve #${base0E};
    @define-color flamingo #${base0F};
    ${builtins.readFile ./style.css} 
    '';

    settings = [{
      layer = "top";
      margin-top = 5;
      margin-left = 5;
      margin-right = 5;
      modules-left = ["hyprland/workspaces" "backlight" "pulseaudio" "network"];
      modules-center = ["clock"];
      modules-right =  ["temperature" "cpu" "memory" "battery" "tray"];
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
        format-bluetooth-muted = " {icon}  {format_source}";
        format-muted = "婢 {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["奄" "奔" "墳"];
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
        format = "{usage}% ({avg_frequency}GHz)  ";
        states = {
          warning = 25;
          critical = 75;
        };
      };
      memory = {
        interval = 30;
        format = "{percentage}% ({used:0.1f}G/{total:0.1f}G)  ";
      };
      battery = {
        bat = "BAT0";
        states = {
          warning = 35;
          critical = 20;
        };
        format = "{capacity}% (-{power}W) {icon} ";
        format-icons = ["" "" "" "" ""];
        format-charging = "{capacity}% (+{power}W) {icon}  ";
      };
      tray = {
        icon-size = 21;
        spacing = 10;
      };
    }];
  };
}
