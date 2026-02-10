{ lib, ext, self }:

data: 

''
  default_type application/json;
  add_header Access-Control-Allow-Origin *;
  return 200 '${builtins.toJSON data}';
''

