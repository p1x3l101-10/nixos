{ ... }:

let
  genUsers = userList: {
    users.users = builtins.listToAttrs (
      map
        (x:
          {
            name = x.name;
            value = {
              initialHashedPassword = x.password;
              isNormalUser = true;
              extraGroups = [ "vsftpd" ];
            };
          }
        )
        userList
    );
  };
in
genUsers [
  { name = "pixel"; password = "$y$j9T$NSMuZ83C3iGB1HqRhcZOy.$6CGZk2KH94gE/gjBro9vioOkOFJw.a4rhQKJI4HzBB9"; }
]
