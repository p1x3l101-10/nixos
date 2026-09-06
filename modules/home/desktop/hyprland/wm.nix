{ ext, pkgs, lib, osConfig, config, ... }:
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
        mkLua = lib.generators.mkLuaInline;
        forceQuote = str: "\"${str}\"";
        mkArgs = args: {
          _args = args;
        };
      in {
        config = {
          xwayland = {
            enabled = true;
            force_zero_scaling = false;
          };
          debug.enable_stdout_logs = 1;
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            resize_on_border = false;
            allow_tearing = true;
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
        curve = (
          let
            toString = x: (if (builtins.isFloat x) then (lib.strings.floatToString x) else (builtins.toString x));
            mkBezier = (
              name:
              { x0
              , y0
              , x1
              , y1
              }:
              mkArgs [name { type = "bezier"; points = [ [x0 y0] [x1 y1] ]; }]
            );
            bezier = name: x0: y0: x1: y1: mkBezier name { inherit x0 y0 x1 y1; };
          in [
            (bezier "easeOutQuint" 0.23 1 0.32 1)
            (bezier "easeInOutCubic" 0.65 0.05 0.36 1)
            (bezier "linear" 0 0 1 1)
            (bezier "almostLinear" 0.5 0.5 0.75 1.0)
            (bezier "quick" 0.15 0 0.1 1)
          ]
        );
        animation = (
          let
            mkAnim = (
              leaf:
              { enabled ? true
              , ...
              }@args:
              mkArgs [({ inherit leaf; } // args)]
            );
            # Similar syntax to hyprlang, helps with converting old animations (also just nicer to work with)
            hyprlangAnim = leaf: onOff: speed: curve: style: mkAnim leaf ({
              enabled = (if (builtins.isBool onOff) then (onOff) else (onOff == 1)); # Hyprlang uses 1 or 0 instead of true false
              bezier = curve;
              inherit speed;
            } // (if (builtins.isNull style) then {} else { inherit style; }));
            # Shorthands
            anim' = leaf: speed: curve: style: hyprlangAnim leaf true speed curve style;
            anim = leaf: speed: curve: hyprlangAnim leaf true speed curve null;
            curveShorthands = {
              def = "default";
              eoq = "easeOutQuint";
              ioc = "easeInOutCubic";
              lin = "linear";
              aln = "almostLinear";
              qck = "quick";
            };
          in (with curveShorthands; [
            (anim "global" 10 def)
            (anim "border" 5.39 eoq)
            (anim "windows" 4.79 eoq)
            (anim' "windowsIn" 4.1 eoq "popin 87%")
            (anim' "windowsOut" 1.49 lin "popin 87%")
            (anim "fadeIn" 1.73 aln)
            (anim "fadeOut" 1.5 aln)
            (anim "fade" 3.03 qck)
            (anim "layers" 3.81 eoq)
            (anim' "layersIn" 4 eoq "fade")
            (anim' "layersOut" 1.5 lin "fade")
            (anim "fadeLayersIn" 1.79 aln)
            (anim "fadeLayersOut" 1.39 aln)
            (anim' "workspaces" 1.94 aln "fade")
            (anim' "workspacesIn" 1.21 aln "fade")
            (anim' "workspacesOut" 1.94 aln "fade")
          ])
        );
        bind = (
          let
            mod = globals.modifierKey;
            # Keybinding stuff
            b'' = keyList: action: flags: (mkArgs [(builtins.concatStringsSep " + " keyList) action flags]);
            b' = keyList: action: (mkArgs [(builtins.concatStringsSep " + " keyList) action]);
            b = key: action: (b' [mod key] action);
            specialKey = keyType: keycode: "${keyType}:${keycode}";
            dsp = action: mkLua "hl.dsp.${action}";
            # Common actions
            exec = cmd: dsp "exec_cmd(${forceQuote cmd})";
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
                act = direction: (dsp "focus({ direction = ${forceQuote direction} })");
              in [
                (b "H" (act "left"))
                (b "J" (act "up"))
                (b "K" (act "down"))
                (b "L" (act "right"))
              ]
            ) ++ ( # Move windows around
              let
                act = direction: (dsp "window.move({ direction = ${forceQuote direction} })");
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
                    (b workspaceKey (dsp "focus({ workspace = ${forceQuote internalWorkspace} })"))
                    # Move window between workspace
                    (b' [mod "SHIFT" workspaceKey] (dsp "window.move({ workspace = ${forceQuote internalWorkspace} })"))
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
                b = mouseButton: action: b'' [mod (specialKey "mouse" mouseButton)] action "{ mouse = true }";
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
    systemd.enable = false;
  };
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
  ];
  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
