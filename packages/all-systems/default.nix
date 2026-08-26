{ ext
, linkFarm
}:

linkFarm "all-systems" (map
  (system:
    {
      name = system.config.networking.hostName;
      path = system.config.system.build.toplevel;
    }
  )
  (with ext.inputs.self.nixosSystems; [
    stellar-pc
    stellar-laptop
    stellar-server
  ])
)
