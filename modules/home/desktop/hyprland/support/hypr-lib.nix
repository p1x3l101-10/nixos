lib: (lib.fix (self: {
  bind'' = modifer: extMod: key: action: (
    let
      prestring = (
        modifer +
        (if (extMod == null) then "" else " " + extMod) + ", " +
        key + ", " +
        action +
        # Check if the action HATES the trailing comma
        (lib.internal.lists.switch (let
            out = "";
          in map (value: { case = (value == action); inherit out; }) [
            "resizewindow"
            "movewindow"
          ])
          ", "
        )
      );
    in
    # Basically this decides if there is a need for the 5th arg
    (lib.internal.lists.switch (let
        out = actionArgs: (prestring + actionArgs);
      in map (value: { case = (value == action); inherit out; }) [
        # List of matches
        "exec"
        "togglespecialworkspace"
        "movetoworkspace"
        "workspace"
        "movefocus"
      ])
      # Default
      prestring
    )
  );
}))
