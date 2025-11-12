{ packId ? ""
, jvmArgs ? [ ]
, userdata
}:

{
  eula = true;
  whitelist = (userdata [ "mcUsername" ] (import ./whitelist.nix)) ++ (import ./whitelist-raw.nix);
  rconStartup = [
    "gamerule playersSleepingPercentage 10"
  ];
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
}
