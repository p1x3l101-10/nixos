{ config, ext, lib, ... }@hmArgs:

let
  # Block got too long, move to other file and then import it
  inherit (import ./hyprland-vars.nix hmArgs)
    globals
    mkLuaInline
    mkArgs
    luaCmds
    monitors
    functions
  ;
  inherit (luaCmds) hl;
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
      numlock_by_default = true;
      touchpad = {
        natural_scroll = true;
        disable_while_typing = false;
      };
    };
    cursor = {
      inactive_timeout = 10;
      hide_on_key_press = false;
    };
    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };
    quirks.prefer_hdr = 2; # Prefer HDR for only gamescope
    plugin.darkwindow.load_shaders = "chromakey";
  };
  curve = (
    let
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
  bind = let inherit (hl) dsp; in (
    with functions.bind; (
      [
        # Main binds
        (b "Q" (dsp.exec_cmd globals.apps.terminal.exec))
        (b "W" (dsp.exec_cmd globals.apps.web.exec))
        (b "C" dsp.window.close)
        (b "E" (dsp.exec_cmd globals.apps.fileManager.exec))
        (b "V" dsp.window.float)
        (b "R" (dsp.exec_cmd._raw globals.spotlight))
        (b ["SHIFT" "R"] (dsp.exec_cmd globals.powerMenu))
        (b ["ALT" "L"] (dsp.exec_cmd._raw globals.lockCmd))
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
        (bnm "Print" (dsp.exec_cmd._raw "grimblast save screen"))
        (bnm ["SHIFT" "Print"] (dsp.exec_cmd._raw "grimblast copy screen"))
        (b "Print" (dsp.exec_cmd._raw "grimblast save area"))
        (b ["SHIFT" "Print"] (dsp.exec_cmd._raw "grimblast copy area"))
        (b ["CTRL" "Print"] (dsp.exec_cmd._raw "grimblast save active"))
        (b ["CTRL" "SHIFT" "Print"] (dsp.exec_cmd._raw "grimblast copy active"))
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
          (xKey: brightAction: (bnm "XF86MonBrightness${xKey}" (dsp.exec_cmd._raw "brightnessctl -e4 -n2 set ${brightAction}")))
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
  on = (
    let
      mkTarget = target: commands: mkArgs [target (mkLuaInline ''
        function()
          ${builtins.concatStringsSep "\n" (map (x: x.expr) commands)}
        end
      '')];
    in
    [
      # pcscd is borked on startup and wont detect a smartcard bc it starts too early
      (mkTarget "hyprland.start" [
        (hl.exec_cmd "systemctl restart pcscd --no-block")
      ])
    ]
  );
  window_rule = (
    let
      types = ext.lib.infusion.mkTypes "Hyprland Settings:window_rule" (yants:
        with yants; let
          mkOptional = attrs: (lib.mapAttrs
            (_: v: option v)
            attrs
          );
        in rec {
          regex = string;
          workspaceSelector = int;
          windowRule_matcher = struct "windowRule_matcher" (mkOptional {
            class = regex;
            content = string;
            focus = bool;
            fullscreen = bool;
            fullscreen_state_client = int;
            fullscreen_state_internal = int;
            float = bool;
            group = bool;
            initial_class = regex;
            initial_title = regex;
            modal = bool;
            pin = bool;
            tag = string;
            workspace = workspaceSelector;
            xdg_tag = regex;
            xwayland = bool;
          });
          windowRule = openStruct "windowRule" { # Open because I cant be bothered to do all the window effects
            name = option string;
            match = windowRule_matcher;
          };
          luaArgs = struct "luaArgs" {
            _args = list any;
          };
          override = type: struct "override" {
            override = bool;
            data = type;
          };
          allowOverride = type: either type (override type);
          stringCastable = eitherN [
            string
            float
          ];
        }
      );
      inherit (types) defun;

      # Helper functions for casting actions (Lua sometypes has horrible syntax)
      filterEmpty = defun (with types; [ (attrs (option any)) (attrs any) ]) (attrs:
        builtins.listToAttrs (
          builtins.filter
          (x: !builtins.isNull x)
          (lib.attrsToList attrs)
        )
      );
      ## Value to check, then attrName (null if not attrset), returns bool if value is set
      checkOptional = defun (with types; [ (either (attrs any) (option any)) (option string) bool ]) (valueToCheck: attrName:
        if (!builtins.isNull attrName) then (
          if (builtins.hasAttr attrName valueToCheck) then (
            !builtins.isNull (valueToCheck."${attrName}")
          ) else false
        ) else (
          !builtins.isNull valueToCheck
        )
      );
      castOverride = defun (with types; [ (allowOverride stringCastable) string ]) (x:
        if x.override then (
          (builtins.toString x.data) + " override"
        ) else (
          builtins.toString x.data
        )
      );
      castingFunctions = {
        opacity = defun (with types; [ (either opacity string) string ]) (opacity:
          if (builtins.isString opacity) then opacity else (
            builtins.concatStringsSep " " (map
              (x:
                if (builtins.isAttrs x) then (
                  castOverride x
                ) else (
                  builtins.toString x
                )
              )
              (
                [opacity.base] ++ (
                  if (checkOptional opacity "inactive") then [opacity.inactive] else (
                    if (checkOptional opacity "fullscreen") then [opacity.base] else []
                  )
                ) ++ (
                    if (checkOptional opacity "fullscreen") then [opacity.fullscreen] else []
                )
              )
            )
          )
        );
      };
      # Primary functions
      mkRule = defun (with types; [ windowRule luaArgs ]) (
        { name ? null
        , match
        , ...
        }@windowRule:
        mkArgs [(
          { match = filterEmpty windowRule.match; }
          // (if (!builtins.isNull name) then { inherit name; } else {})
          // (lib.mapAttrs
            (name: value:
              if (builtins.hasAttr name castingFunctions) then (
                castingFunctions."${name}" value
              ) else (
                value
              )
            )
            (filterEmpty (builtins.removeAttrs windowRule (if (builtins.hasAttr "name" windowRule) then [ "name" "match" ] else [ "match" ])))
          )
        )]
      );
      # mkRule wrappers
      mkTransparent = defun (with types; [ windowRule_matcher float luaArgs ]) (match: targetOpacity:
        mkRule {
          inherit match;
          "darkwindow:shade" = hl.plugin.darkwindow.build_rule_effect {
            shader = "enforceTransparent";
            inherit targetOpacity;
          };
        }
      );
      noMaximize = defun (with types; [ windowRule_matcher luaArgs ]) (match:
        mkRule {
          inherit match;
          suppress_event = "maximize";
        }
      );
      # Common matches
      matchTargets = {
        kitty = {
          class = "kitty";
        };
      };
    in
    ((types.list types.luaArgs) [
      # Transparency
      (mkTransparent matchTargets.kitty config.stylix.opacity.terminal)
      # Stop kitty from fullscreening
      (noMaximize matchTargets.kitty)
    ])
  );
  "plugin.darkwindow.load_shader" = (
    let
      types = ext.lib.infusion.mkTypes "Hyprland Settings:darkwindow:load_shaders" (yants: with yants; rec {
        transformShader = openStruct "shaderTransform" {
          from = string;
          args = string;
        };
        shaderConstructor = eitherN [ transformShader ];
        luaArgs = struct "luaArgs" {
          _args = list any;
        };
      });
      inherit (types) defun;
      mkShader = defun (with types; [ string shaderConstructor luaArgs ]) (name: shaderConstructor:
        mkArgs [
          name
          shaderConstructor
        ]
      );
    in
    ((types.list types.luaArgs) [
      (mkShader "enforceTransparent" {
        from = "chromakey";
        args = with config.lib.stylix.colors; "bkg=[${base00-dec-r} ${base00-dec-g} ${base00-dec-b}]";
      })
    ])
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
