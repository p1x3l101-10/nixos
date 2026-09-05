{ ext, pkgs, lib, osConfig, ... }:
let
  inherit (ext) inputs system;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # Nixos manages these packages
    package = null;
    portalPackage = null;
    configType = "lua";
    settings = (
      let
        globals = import ./support/hypr-globals.nix { inherit pkgs lib ext; };
        # Shortcut for inline lua
        lua = lib.generators.mkLuaInline;
        lQuote = str: "\"${str}\"";
        # Shortcut for that strange lua thing we do
        mkLua = args: {
          _args = args;
        };
      in {
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            resize_on_border = false;
            allow_tearing = false;
          };
          decoration = {
            rounding = 10;
            rounding_power = 2;
            active_opacity = "1.0";
            inactive_opacity = "1.0";
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
            };
            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = "0.1696";
            };
          };
          animations = {
            enabled = true;
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];
            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
          };
          input = {
            kb_layout = "us";
            follow_mouse = false;
            sensitivity = 0;
            touchpad = {
              natural_scroll = true;
              disable_while_typing = false;
            };
          };
        };
        bind = (
          let
            mod = globals.modifierKey;
            # Keybinding stuff
            b'' = keyList: action: flags: (mkLua [(builtins.concatStringsSep " + " keyList) action (lua flags)]);
            b' = keyList: action: (mkLua [(builtins.concatStringsSep " + " keyList) action]);
            b = key: action: (b' [mod key] action);
            specialKey = keyType: keycode: "${keyType}:${keycode}";
            dsp = action: lua "hl.dsp.${action}";
            # Common actions
            exec = cmd: dsp "exec_cmd(${lQuote cmd})";
          in (
            [
              # Main binds
              (b "Q" (exec globals.apps.terminal.exec))
              (b "W" (exec globals.apps.web.exec))
              (b "C" (dsp "window.close()"))
              (b "E" (exec globals.apps.fileManager.exec))
              (b "V" (dsp "window.float()"))
              (b "R" (exec globals.spotlight))
              (b' [mod "ALT" "L"] (exec globals.lockCmd))
              (b "F11" (dsp "window.fullscreen()"))
            ] ++ (# Move focus between windows
              let
                act = direction: (dsp "focus({ direction = ${lQuote direction} })");
              in [
                (b "H" (act "left"))
                (b "J" (act "up"))
                (b "K" (act "down"))
                (b "L" (act "right"))
              ]
            ) ++ ( # Move windows around
              let
                act = direction: (dsp "window.move({ direction = ${lQuote direction} })");
                b = key: action: b' [mod "SHIFT" key] action;
              in [
                (b "H" (act "left"))
                (b "J" (act "up"))
                (b "K" (act "down"))
                (b "L" (act "right"))
              ]
            ) ++ ( # Workspace keybinds
              lib.flatten (map
                (internalWorkspace: let
                  workspaceKey = if (internalWorkspace == "10") then "0" else internalWorkspace;
                in
                  [
                    # Move focus between workspaces
                    (b workspaceKey (dsp "focus({ workspace = ${lQuote internalWorkspace} })"))
                    # Move window between workspace
                    (b [mod "SHIFT" workspaceKey] (dsp "window.move({ workspace = ${lQuote internalWorkspace} })"))
                  ]
                )
                (builtins.genList (x: (builtins.toString (x + 1))) 10) # 10 workspaces
              )
            ) ++ [ # Screenshot stuff
              (b' ["Print"] (exec "grimblast save screen"))
              (b' ["SHIFT" "Print"] (exec "grimblast copy screen"))
              (b' [mod "Print"] (exec "grimblast save area"))
              (b' [mod "SHIFT" "Print"] (exec "grimblast copy area"))
              (b' [mod "CTRL" "Print"] (exec "grimblast save active"))
              (b' [mod "CTRL" "SHIFT" "Print"] (exec "grimblast copy active"))
            ] ++ ( # XFree86 Actions
              (lib.attrsets.mapAttrsToList
                (xKey: action: (b' ["XF86Audio${xKey}"] (exec action)))
                {
                  RaiseVolume = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
                  LowerVolume = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
                  Mute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                  MicMute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                  Next = "playerctl next";
                  Play = "playerctl play-pause";
                  Pause = "playerctl play-pause";
                  Prev = "playerctl previous";
                }
              ) ++ (lib.attrsets.mapAttrsToList
                (xKey: brightAction: (b' ["XF86MonBrightness${xKey}"] (exec "brightnessctl -e4 -n2 set ${brightAction}")))
                {
                  Up = "5%+";
                  Down = "5%-";
                }
              )
            ) ++ (let # Mouse binds
                b = mouseButton: action: b'' [mod (specialKey "mouse" mouseButton)] action { mouse = true; };
                lmb = "272";
                rmb = "273";
                #mmb = "274";
              in [ 
                (b lmb (dsp "window.drag()"))
                (b rmb (dsp "window.resize()"))
              ]
            )
          )
        );
      } // (let
        monitors = {
          applies = (osConfig.networking.hostName == "stellar-pc");
          primary = "DP-1";
          secondary = "DP-2";
        };
      in
        if (monitors.applies) then {
          workspace_rule = (
            # Primary
            (map
              (workspace: {
                inherit workspace;
                monitor = monitors.primary;
              })
              (builtins.genList (x: (x * 2) + 1) 5)
            )
            # Secondary
            ++ (map
              (workspace: {
                inherit workspace;
                monitor = monitors.secondary;
              })
              (builtins.genList (x: (x * 2) + 2) 5)
            )
          );
          monitor = [
            {
              output = monitors.primary;
              position = "0x0";
            }
            {
              output = monitors.secondary;
              position = "-1920x0";
            }
          ];
        } else {}
      )
    );
    systemd.enable = true;
    xwayland.enable = true;
  };
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
  ];
}
