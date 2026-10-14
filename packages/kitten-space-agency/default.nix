{ ext
, info ? (builtins.fromJSON (builtins.readFile ./info.json))
, callPackage # To load the other bundles
, gameFiles ? callPackage ./gameFiles.nix { inherit info; } # Game bundle
, buildFHSEnv
, writeShellScript
, writeShellApplication
, jq
, xdg-utils
}:

buildFHSEnv {
  inherit (info) name;

  targetPkgs = pkgs: with pkgs; [
    stdenv.cc.cc.lib
    vulkan-loader
    icu
    openssl
    zlib
    libX11
    libXrandr
    libXi
    libXcursor
    libXinerama
    libxcb
    wayland
    libxkbcommon
  ];

  runScript = writeShellScript "${info.name}-launcher" ''
    cd ${gameFiles}/lib/ksa
    exec ./KSA "$@"
  '';

  passthru.get-token = writeShellApplication {
    name = "ksa-get-token";
    runtimeInputs = [
      jq
      xdg-utils
    ];

    text = ''
      echo "Opening https://ahwoo.com in your browser. Log in if needed." >&2
      xdg-open 'https://ahwoo.com/app/100000/kitten-space-agency' 2>/dev/null || true

      echo "" >&2
      echo "The Keycloak adapter holds tokens in memory, so use the Network tab:" >&2
      echo "" >&2
      echo "  1. Open DevTools (F12) → Network tab" >&2
      echo "  2. Check 'Preserve log' in Chrome or click the gear and then check "Persist Logs" in Firefox" >&2
      echo "  3. Refresh the page (Ctrl+R)" >&2
      echo "  4. In the filter box type: token" >&2
      echo "  5. Click the POST request to auth.ahwoo.com/.../token" >&2
      echo "  6. Go to the Response tab and copy the value of \"refresh_token\"" >&2
      echo "" >&2
      echo "Paste the refresh_token value here and press Enter:" >&2

      read -r refresh_token
      refresh_token="''${refresh_token#\"}"
      refresh_token="''${refresh_token%\"}"

      if [ -z "$refresh_token" ]; then
        echo "No token provided." >&2
        exit 1
      fi

      # Validate it works before printing
      result=$(curl -fsSL \
        --data-urlencode "grant_type=refresh_token" \
        --data-urlencode "client_id=ahwoo-client" \
        --data-urlencode "refresh_token=$refresh_token" \
        'https://auth.ahwoo.com/realms/ahwoo/protocol/openid-connect/token')

      # Keycloak rotates refresh tokens on each use. Save the NEW one from the validation response, not the original (which is now invalidated).
      new_refresh_token=$(echo "$result" | jq -r '.refresh_token // empty')

      if [ -n "$new_refresh_token" ]; then
        echo "Token validated successfully." >&2
        mkdir -p "''${XDG_CONFIG_HOME:-~/.config}/ksa"
        printf '%s' "$new_refresh_token" > "''${XDG_CONFIG_HOME:-~/.config}/ksa/refresh-token"
      else
        echo "Token validation failed:" >&2
        echo "$result" | jq . >&2
        exit 1
      fi
    '';
  };

  meta = {
    inherit (info.meta) description homepage;
    inherit (gameFiles.meta) platforms;
    mainProgram = "${info.name}-launcher";
    passthru.gameFiles = gameFiles; # To allow threading an override
  };
}
