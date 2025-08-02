# See https://wiki.hyprland.org/Configuring
pkgs: lib0:
let
  # Layer on an additional lib namespace (why do i do this to myself)
  lib1 = import ./hypr-lib.nix lib0;
  lib = lib0.extend (finalLib: prevLib: { hypr = lib1; });
  # "Global" variables
  globals = import ./hypr-globals.nix pkgs lib0;
  # Bind helpers
  bindScope = lib.fix (self:{
    # Master function
    inherit (lib.hypr) bind'';
    # `bind'` lets you specify aditional modifers in addition to the normal one
    bind' = self.bind'' globals.modiferKey;
    bind = self.bind' null;
    # Short for "bind no mod", useful for volume keys and such
    bnm = self.bind'' "" "";
    # too much typing, `b` is shorthand for "bind" in `b` and `b'`
    b' = self.bind';
    b = self.bind;
  });
in {
  monitor = ",preferred,auto,auto";
  general = {
    gaps_in = 5;
    gaps_out = 10;
    border_size = 2;
    resize_on_border = false;
    allow_tearing = false;
    layout = "dwindle";
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
  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };
  master.new_status = "master";
  misc = {
    force_default_wallpaper = -1;
  };
  input = {
    kb_layout = "us";
    /* the template had these, i dunno how to do this in nix, so just a comment block ig...
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =
    */
    follow_mouse = false;
    sensitivity = 0;
    touchpad.natural_scroll = true;
  };
  gestures.workspace_swipe = false;
  bind = let inherit (bindScope) bind' bind bnm bind'' b' b; in [
    # Main binds
    (b "Q" "exec" globals.apps.terminal.exec)
    (b "W" "exec" "zen")
    (b "C" "killactive")
    (b "E" "exec" globals.apps.fileManager.exec)
    (b "V" "togglefloating")
    (b "R" "exec" globals.spotlight)
    (b "L" "exec" "loginctl lock-session $XDG_SESSION")
    (b "P" "pseudo") # dwindle
    (b "J" "togglesplit") # dwindle
    # Get some pesky games to work
    (b "F11" "fullscreen")
    # Move focus
    (b' "SHIFT" "H" "movefocus" "l")
    (b' "SHIFT" "J" "movefocus" "u")
    (b' "SHIFT" "K" "movefocus" "d")
    (b' "SHIFT" "L" "movefocus" "r")
    # BEGIN: Numbered workspaces corrisponding to 1-0 on kbd
  ] ++ (map (value: (bind value "workspace" value))
    ((builtins.genList (x: (builtins.toString (x + 1))) 9)) # 9 Workspaces
  ) ++ [
    (bind "0" "workspace" "10") # And the 10th, because i cant truncate to 0 sadly
    # END: Numbered workspaces
    # BEGIN: Oh boy, this again but with shift...
  ] ++ (map (value: (bind' "SHIFT" value "movetoworkspace" value))
    ((builtins.genList (x: (builtins.toString (x + 1))) 9)) # 9 Workspaces
  ) ++ [
    (bind' "SHIFT" "0" "movetoworkspace" "10") # And the 10th, because i cant truncate to 0 sadly
    # END: Workspace moving
    # Scratchpad workspace
    (b "S" "togglespecialworkspace" "magic")
    (b' "SHIFT" "S" "movetoworkspace" "special:magic")
    # Scroll through workspace
    (b "mouse_up" "workspace" "e+1")
    (b "mouse_down" "workspace" "e-1")
    # Screenshot stuff
    (b "Print" "exec" "grimblast save area")
    (b' "SHIFT" "Print" "exec" "grimblast copy area")
    (bnm "Print" "exec" "grimblast save screen")
    (bind'' "" "SHIFT" "Print" "exec" "grimblast copy screen")
    (b' "CTRL" "Print" "exec" "grimblast save active")
    (b' "SHIFT+CTRL" "Print" "exec" "grimblast copy active")
  ];

  bindm = let inherit (bindScope) b; in [
    # Resize windows with mouse dragging
    (b "mouse:272" "movewindow")
    (b "mouse:273" "resizewindow")
  ];

  bindel = let inherit (bindScope) bnm; in (map (value: # I got lazy and made a function
    (lib.mapAttrs' (key: action:
      (lib.nameValuePair 
        ("out")
        (bnm "XF86Audio${key}" "exec" "wpctl ${action}")
      )
    ) value).out
  ) [
    { RaiseVolume = "set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"; }
    { LowerVolume = "set-volume @DEFAULT_AUDIO_SINK@ 5%-"; }
    { Mute = "set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
    { MicMute = "set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
  ]) ++ [
    (bnm "XF86MonBrightnessUp" "exec" "brightnessctl -e4 -n2 set 5%+")
    (bnm "XF86MonBrightnessDown" "exec" "brightnessctl -e4 -n2 set 5%-")
  ];

  bindl = let inherit (bindScope) bnm; in (map (value: # I got lazy and made a function
    (lib.mapAttrs' (key: action:
      (lib.nameValuePair 
        ("out")
        (bnm "XF86Audio${key}" "exec" "playerctl ${action}")
      )
    ) value).out
  ) [
    { Next = "next"; }
    { Play = "play-pause"; }
    { Pause = "play-pause"; }
    { Prev = "previous"; }
  ]);

  windowrule = [
    "suppressevent maximize, class:.*" # Ignore maximize requests from apps.
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0" # Fix some dragging issues with XWayland
  ];
}
