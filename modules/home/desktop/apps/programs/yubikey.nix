{ pkgs, ... }:

{
  pam.u2f.authorizedYubiKeys = [
    {
      keyHandle = "8ER/XIeoSDlZQ7khXXWD88eLGoYNA5+hGfDFhMMUPyRVY2MkOoAPFjZgUJbwkVM/JanPg3BLu3+dfgRQBC9MHA==";
      userKey = "bbjgMveX0874lnzi2i5PY5eT4fTAm6KJvATQE4YZM8eSF44kp1b4c3N1Z/tBI7cgT2JIINkYRjqz67OJSyyenw==";
      coseType = "es256";
      options = "+presence";
    }
    {
      keyHandle = "C0QSwSmxjoSH9N5Y9RXEg8pLTp4a5q2zLId3FeWXVvsahqEr1h0wLzkTP+lhPawYgX33cwgFdM9iUdgh3cNj6w==";
      userKey = "9s0vPcznb8jWKoosXBwaiJPbqzIE1a95o9+04fkb1QtlZ+KJxT7uywWg61GDYaAboZxpx+mmCg9+86bhAWeoeA==";
      coseType = "es256";
      options = "+presence";
    }
  ];
  services.yubikey-agent.enable = true;
  home.packages = with pkgs; [
    yubikey-personalization
    age-plugin-yubikey
    yubico-piv-tool
    yubioath-flutter
  ];
}
