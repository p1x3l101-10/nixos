{ globals, ... }:

{
  base_url = globals.server.dns.basename;
  compile_sass = true;
  build_search_index = false;
  extra = {};
}
