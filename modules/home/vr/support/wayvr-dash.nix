{ mainProg, ... }:
{
  dashboard = {
    exec = mainProg;
    args = "";
    env = [];
  };
}
