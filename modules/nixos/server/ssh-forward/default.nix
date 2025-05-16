{ ... }:

{
  imports = [
    ./module.nix
  ];
  networking.sshForwarding = {
    enable = true;
    trustedHostKeys = [
      "piplup.pp.ua ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu2YSKzbmW2D/Iq8oxAVqeHZ0CXGmnRa++uWaeV3sQmUS82v0yQXjOlXHY6hqRZlqkE2lM0FGvLxzPTBnls1aRFsR1dzVm2/efyfxi1Pv+7S0Gi96gisMiy+U2/bRUI/Yq0c6jpMZGCEAiiZtcexKLIlewTJwM5SQFd3kIk35kCIA2UfiZ5XUlfcURg7Gc1OMQw3wRP7F1zGy/NFxZUn1YbVZx+uRmP65YyvMtXek0coKuoAdjvR+7/rXDMCPwDIje4lYPDp/vt9bigXbkxc7uPAmtBq2hWZcfoV7ro9X30Ty/YlYn5h536tz0s6/8x/4/2u0W0SV3QQpGFRWBqIYX"
    ];
    sshPort = 2222;
    keyFile = "/nix/host/keys/ssh-tunnel/id.key";
  };
}