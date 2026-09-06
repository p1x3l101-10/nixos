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
        inherit (lib.generators) mkLuaInline toLua;
        mkArgs = args: {
          _args = args;
        };
        dsp = (
          let
            mkDsp = target: mkLuaInline "hl.dsp.${target}";
          in {
            exec_cmd = arg: mkDsp "exec_cmd(${toLua { } arg})";
            focus = arg: mkDsp "focus(${toLua { } arg})";
            window = {
              move = arg: mkDsp "window.move(${toLua { } arg})";
              drag = mkDsp "window.drag()";
              resize = mkDsp "window.resize()";
              close = mkDsp "window.close()";
              kill = mkDsp "window.kill()";
              fullscreen = mkDsp "window.fullscreen()";
              float = mkDsp "window.float()";
            };
            workspace = {
              move = arg: mkDsp "workspace.move(${toLua { } arg})";
            };
          }
        );
        monitors = (
          let
            inherit (osConfig.networking) hostName;
            mkMon = attrs: (
              if (builtins.hasAttr hostName attrs) then (attrs."${hostName}") else null
            );
            mkCount = attrs: (
              if (builtins.hasAttr hostName attrs) then (attrs."${hostName}") else 1
            );
          in {
            count = mkCount {
              stellar-pc = 2;
            };
            primary = mkMon {
              stellar-pc = {
                name = "DP-1";
                offset = "0x0";
              };
            };
            secondary = mkMon {
              stellar-pc = {
                name = "DP-2";
                offset = "-1920x0";
              };
            };
          }
        );
        functions = lib.fix (final: {
          keys = lib.fix (finalKeys: {
            special = class: code: "${class}:${builtins.toString code}";
            mouse = {
              left = finalKeys.special "mouse" 272;
              right = finalKeys.special "mouse" 273;
              middle = finalKeys.special "mouse" 274;
            };
          });
          bind = lib.fix (finalBind: {
            bind = (
              { keys
              , dispatcher
              , options ? { }
              , autoMod ? true
              }:
              mkArgs [
                # All this does is process the keys to something hyprland can take
                # Optionally lets the keys be as a list
                # Also handles automatically adding the modifier key when enabled
                ( 
                  if (builtins.isList keys) then (
                    builtins.concatStringsSep " + " (
                      (
                        if (autoMod && (!builtins.elem globals.mod keys)) then (
                          [ globals.modifierKey ]
                        ) else ([])
                      ) ++ keys
                    )
                  ) else (
                    if (autoMod && (!lib.strings.hasInfix globals.modifierKey keys)) then (
                      globals.modifierKey + " + " + keys
                    ) else keys
                  )
                )
                dispatcher
                options
              ]
            );
            b = keys: dispatcher: finalBind.bind { inherit keys dispatcher; };
            bnm = keys: dispatcher: finalBind.bind { inherit keys dispatcher; autoMod = false; };
            b' = keys: dispatcher: options: finalBind.bind { inherit keys dispatcher options; };
            bnm' = keys: dispatcher: options: finalBind.bind { inherit keys dispatcher options; autoMod = false; };
          });
        });
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
          with functions.bind; (
            [
              # Main binds
              (b "Q" (dsp.exec_cmd globals.apps.terminal.exec))
              (b "W" (dsp.exec_cmd globals.apps.web.exec))
              (b "C" dsp.window.close)
              (b "E" (dsp.exec_cmd globals.apps.fileManager.exec))
              (b "V" dsp.window.float)
              (b "R" (dsp.exec_cmd globals.spotlight))
              (b ["ALT" "L"] (dsp.exec_cmd globals.lockCmd))
              (b "F11" dsp.window.fullscreen)
            ] ++ (# Move focus between windows
              let
                act = direction: dsp.focus { inherit direction; };
              in [
                (b "H" (act "left"))
                (b "J" (act "up"))
                (b "K" (act "down"))
                (b "L" (act "right"))
              ]
            ) ++ ( # Move windows around
              let
                act = direction: dsp.window.move { inherit direction; };
                b = key: dispatcher: bind { keys = ["SHIFT" key]; inherit dispatcher; };
              in [
                (b "H" (act "left"))
                (b "J" (act "up"))
                (b "K" (act "down"))
                (b "L" (act "right"))
              ]
            ) ++ ( # Workspace keybinds
              lib.flatten (map
                (workspace: let
                  workspaceKey = if (workspace == "10") then "0" else workspace;
                in
                  [
                    # Move focus between workspaces
                    (b workspaceKey (dsp.focus { inherit workspace; }))
                    # Move window between workspace
                    (b ["SHIFT" workspaceKey] (dsp.window.move { inherit workspace; }))
                  ]
                )
                (builtins.genList (x: (builtins.toString (x + 1))) 10) # 10 workspaces
              )
            ) ++ [ # Screenshot stuff
              (bnm "Print" (dsp.exec_cmd "grimblast save screen"))
              (bnm ["SHIFT" "Print"] (dsp.exec_cmd "grimblast copy screen"))
              (b "Print" (dsp.exec_cmd "grimblast save area"))
              (b ["SHIFT" "Print"] (dsp.exec_cmd "grimblast copy area"))
              (b ["CTRL" "Print"] (dsp.exec_cmd "grimblast save active"))
              (b ["CTRL" "SHIFT" "Print"] (dsp.exec_cmd "grimblast copy active"))
            ] ++ ( # XFree86 Actions
              (lib.attrsets.mapAttrsToList
                (xKey: action: (bnm "XF86Audio${xKey}" (dsp.exec_cmd action)))
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
                (xKey: brightAction: (b "XF86MonBrightness${xKey}" (dsp.exec_cmd "brightnessctl -e4 -n2 set ${brightAction}")))
                {
                  Up = "5%+";
                  Down = "5%-";
                }
              )
            ) ++ (with functions.keys; [
              (b' mouse.left dsp.window.drag { mouse = true; })
              (b' mouse.right dsp.window.resize { mouse = true; })
            ])
          )
        );
      } // (
        if (monitors.count == 2) then {
          workspace_rule = (
            # Primary
            (map
              (workspace: {
                inherit workspace;
                monitor = monitors.primary.name;
              })
              (builtins.genList (x: (x * 2) + 1) 5)
            )
            # Secondary
            ++ (map
              (workspace: {
                inherit workspace;
                monitor = monitors.secondary.name;
              })
              (builtins.genList (x: (x * 2) + 2) 5)
            )
          );
          monitor = [
            {
              output = monitors.primary.name;
              position = monitors.primary.offset;
            }
            {
              output = monitors.secondary.name;
              position = monitors.secondary.offset;
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
