{ globals, config, ... }:

let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in {
  services.forgejo = {
    enable = globals.server.dns.exists;
    database.type = "postgres";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.${globals.server.dns.name}";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${srv.DOMAIN}/"; 
        HTTP_PORT = 3000;
      };
      service.DISABLE_REGISTRATION = true; 
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };
}