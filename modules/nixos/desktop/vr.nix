{ config, pkgs, lib, inputs, ... }:
let
  defaultRuntime = "Envision";
  monadoHelperShell = pkgs.writeShellScriptBin "setup-monado-handModels.sh" ''
    mkdir -p ~/.local/share/monado
    cd ~/.local/share/monado
    git clone https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models
  '';
in
lib.mkIf (config.networking.hostName == "pixels-pc") {
  # Monado
  services.monado = {
    enable = true;
    defaultRuntime = (defaultRuntime == "Envision");
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };
  # WiVRn
  services.wivrn = {
    enable = true;
    openFirewall = true;
    defaultRuntime = (defaultRuntime == "WiVRn");
    autoStart = true;
    config = {
      enable = true;
      json = {
        scale = 1.0;
        bitrate = 100000000;
        encoders = [
          {
            encoder = "vaapi";
            codec = "h265";
            # 1.0 x 1.0 scaling
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
      };
    };
  };
  # Envsion
  programs.envision = {
    enable = true;
    package = inputs.self.packages.x86_64-linux.envision.override {
      extraPackages = with pkgs; (with gst_all_1; [
        gstreamer
        gst-plugins-base
        gst-plugins-good
        /*
                gst-plugins-bag
                gst-plugins-ugly
                */
        gst-libav
        gst-vaapi
      ]) ++ [
        glslang
        libdrm
        openxr-loader
        opencomposite
        khronos-ocl-icd-loader
        vulkan-loader
        openssl
        libnotify.dev
        libnotify
        libsysprof-capture
        gdk-pixbuf.dev
        gdk-pixbuf
        libbsd.dev
        libbsd
        libpng.dev
        libpng
        util-linux.dev
        util-linux
        libtiff.dev
        libtiff
        libwebp
        xr-hardware
        lerc.dev
        lerc
        wayland
        libglvnd
        libglvnd.dev
        SDL2
        SDL2.dev
        udev
        udev.dev
      ]
      # WiVRn build inputs
      ++ [
        avahi
        boost
        bluez
        cjson
        cli11
        dbus
        eigen
        elfutils
        ffmpeg
        freetype
        glib
        glm
        gst_all_1.gst-plugins-base
        gst_all_1.gstreamer
        harfbuzz
        hidapi
        libbsd
        libdrm
        libdwg
        libGL
        libjpeg
        libmd
        libnotify
        librealsense
        libsurvive
        libunwind
        libusb1
        libuvc
        libva
        xorg.libX11
        xorg.libXrandr
        libpulseaudio
        nlohmann_json
        opencv4
        openhmd
        openvr
        openxr-loader
        onnxruntime
        orc
        pipewire
        qt6.qtbase
        qt6.qttools
        SDL2
        shaderc
        spdlog
        systemd
        udev
        vulkan-headers
        vulkan-loader
        wayland
        wayland-protocols
        wayland-scanner
        x264
      ];
      extraProfile = ''
        export OPENSSL_ROOT_DIR="${pkgs.openssl}"
      '';
    };
  };
  # Kernel patches
  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }
  ];
  # CoreCTRL
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xfffd7fff";
    };
  };
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.corectrl.helper.init" ||
            action.id == "org.corectrl.helperkiller.init") &&
            subject.local == true &&
            subject.active == true &&
            subject.isInGroup("wheel")) {
                return polkit.Result.YES;
            }
        }
    );
  '';
  # Others
  environment.systemPackages = with pkgs; [
    monadoHelperShell
    wlx-overlay-s
    opencomposite
    xr-hardware
    stardust-xr-server
    stardust-xr-gravity
    stardust-xr-phobetor
    stardust-xr-magnetar
    stardust-xr-flatland
    stardust-xr-protostar
    stardust-xr-sphereland
    stardust-xr-atmosphere
    stardust-xr-kiara
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
