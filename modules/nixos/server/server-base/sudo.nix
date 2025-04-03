{ ... }:
{
  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
    extraRules = [
      {
        users = [ "pixel" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
