lib: (lib.fix (self: {
  bind'' = modifer: extMod: key: action: (
    modifer +
    (if (extMod == null) then "" else " " + extMod) + ", " +
    key + ", " +
    action + ", "
    # Basically this decides if there is a need for the 5th arg
    (lib.internal.lists.switch (let
        out = actionArgs: (actionArgs);
      in lib.lists.forEach (value: { case = value; inherit out; }) [
        # List of matches
        "exec"
        "togglespecialworkspace"
        "movetoworkspace"
        "workspace"
        "movefocus"
      ]
    )
    )
  );
}))