{ pkgs, lib, ext, ... }:

lib.fix (self: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
  services.udisks2.enable = true;
  programs.uwsm.enable = true;
  # Greeter
  services.displayManager.ly = {
    enable = true;
    settings = {
      allow_empty_password = false;
      animation = "colormix";
      animation_timeout_sec = 0;
      asterisk = "*";
      auth_fails = 3;
      bg = "0x00000000";
      bigclock = "en";
      blank_box = true;
      border_fg = "0x00FFFFFF";
      box_title = "null";
      brightness_down_cmd = "brightnessctl -q s 10%-";
      brightness_down_key = "F5";
      brightness_up_cmd = "brightnessctl -q s +10%";
      brightness_up_key = "F6";
      clear_password = false;
      clock = "null";
      cmatrix_fg = "0x0000FF00";
      cmatrix_min_codepoint = "0x21";
      cmatrix_max_codepoint = "0x7B";
      colormix_col1 = "0x00FF0000";
      colormix_col2 = "0x000000FF";
      colormix_col3 = "0x20000000";
      custom_sessions = "$CONFIG_DIRECTORY/ly/custom-sessions";
      default_input = "login";
      doom_fire_height = "6";
      doom_fire_spread = "2";
      doom_top_color = "0x009F2707";
      doom_middle_color = "0x00C78F17";
      doom_bottom_color = "0x00FFFFFF";
      error_bg = "0x00000000";
      error_fg = "0x01FF0000";
      fg = "0x00FFFFFF";
      gameoflife_entropy_interval = "10";
      gameoflife_fg = "0x0000FF00";
      gameoflife_frame_delay = "6";
      gameoflife_initial_density = "0.4";
      hide_borders = false;
      hide_version_string = false;
      hide_key_hints = false;
      initial_info_text = "null";
      input_len = "34";
      lang = "en";
      load = true;
      login_cmd = "null";
      login_defs_path = "/etc/login.defs";
      logout_cmd = "null";
      margin_box_h = "2";
      margin_box_v = "1";
      min_refresh_delta = "5";
      numlock = false;
      path = "/run/current-system/sw/bin:/run/booted-system/sw/bin";
      restart_cmd = "systemctl reboot";
      restart_key = "F2";
      save = true;
      service_name = "ly";
      session_log = "ly-session.log";
      setup_cmd = builtins.toString (pkgs.writeShellScript "ly-setup" (builtins.readFile ./support/ly-setup.sh));
      shutdown_cmd = "systemctl shutdown";
      shutdown_key = "F1";
      sleep_cmd = "null";
      sleep_key = "F3";
      text_in_center = false;
      tty = "tty1";
      vi_default_mode = "normal";
      vi_mode = false;
      waylandsessions = "/run/current-system/sw/share/wayland-sessions";
      x_cmd = "/run/current-system/sw/bin/X";
      xauth_cmd = "/run/current-system/sw/bin/xauth";
      xinitrc = "~/.xinitrc";
      xsessions = "/run/current-system/sw/share/xsessions";
    };
  };
  /*
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = ""; # ReGreet provides a (basic) default here
        user = "greeter";
      };
    };
  };
  users.extraUsers.greeter = {
    isSystemUser = true;
    home = "/var/lib/greetd";
    createHome = true;
  };
  programs.regreet = {
    enable = true;
    settings = {
      background.path = ext.assets.img."login.png";
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
      widget.clock.format = "%I:%M:%S %P";
    };
  };
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
  '';
  environment.persistence."/nix/host/state/System".directories = [
    "/var/lib/regreet"
  ];
  */
})
