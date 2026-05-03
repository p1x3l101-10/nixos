{ packId ? ""
, jvmArgs ? [ ]
, userdata
, gamerules ? { playersSleepingPercentage = 10; }
, difficulty ? "hard"
}:

let
  mapAttrsToList = f: attrs: builtins.attrValues (builtins.mapAttrs f attrs);
  toRuleString = x: if (builtins.isBool x) then (if x then "true" else "false") else (builtins.toString x);
in {
  eula = true;
  whitelist = (userdata [ "mcUsername" ] (import ./whitelist.nix)) ++ (import ./whitelist-raw.nix);
  rcon.startup = ((mapAttrsToList
    (rule: value: "gamerule ${rule} ${toRuleString value}")
    gamerules
  ) ++ [
    "difficulty ${difficulty}"
  ]);
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
  regionFileCompression = "lz4";
}
