{ ... }:

{
  programs.iamb = {
    enable = true;
    settings = {
      default_profile = "personal";
      profiles.personal.user_id = "@pixel:exsmachina.org";
      settings = {
        notifications.enabled = true;
        image_preview.protocol = {
          type = "kitty";
          size = {
            height = 10;
            width = 66;
          };
        };
      };
    };
  };
}
