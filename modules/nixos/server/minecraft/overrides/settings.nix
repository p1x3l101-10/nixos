{ packId ? ""
, jvmArgs ? [ ]
, userdata
, gamerules ? { playersSleepingPercentage = 10; }
}:

let
  mapAttrsToList = f: attrs: builtins.attrValues (builtins.mapAttrs f attrs);
in {
  eula = true;
  whitelist = (userdata [ "mcUsername" ] (import ./whitelist.nix)) ++ (import ./whitelist-raw.nix);
  rcon.startup = (mapAttrsToList
    (rule: value: "gamerule ${rule} ${builtins.toString value}")
    gamerules
  );
  memory = 8;
  java.args = (
    if (packId == "") then
      jvmArgs
    else
      (import ./packargs.nix {
        inherit packId;
        extraArgs = jvmArgs;
      })
  );
  allowFlight = true;
  allowCommandBlocks = true;
  broadcastRconToOps = false;
  spawnProtection = 0;
}
