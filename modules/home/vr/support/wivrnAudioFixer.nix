{ lib
, writeShellApplication
, wireplumber
, pipewire
}:

writeShellApplication {
  name = "toggle";
  runtimeInputs = [
    wireplumber
    pipewire
  ];
  text = builtins.readFile ./res/wivrnAudioToggle.bash;
}
