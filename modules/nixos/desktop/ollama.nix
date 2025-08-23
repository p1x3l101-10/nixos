{ ... }:

{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    models = [
      "qwen2.5:32b" # 20 gigs, pretty dang large lol
    ];
  };
}
