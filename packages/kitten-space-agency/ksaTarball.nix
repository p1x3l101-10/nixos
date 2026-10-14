{ info
, refreshToken ? builtins.getEnv "KSA_REFRESH_TOKEN"
, stdenvNoCC
, curl
, jq
, cacert
}:

stdenvNoCC.mkDerivation {
  name = "${info.name}-tarball";
  inherit (info) version;

  KSA_REFRESH_TOKEN = refreshToken;

  outputHash = info.tarball.hash;
  outputHashAlgo = info.tarball.algo;
  outputHashMode = info.tarball.mode;

  nativeBuildInputs = [
    curl
    jq
    cacert
  ];

  buildCommand = ''
    # 1. Exchange the stored refresh token for a fresh access token
    if [ -z "$KSA_REFRESH_TOKEN" ]; then
      echo "KSA: KSA_REFRESH_TOKEN is empty — pass it via: KSA_REFRESH_TOKEN=\$(cat ~/.config/ksa/refresh-token) nix build --impure" >&2
      exit 1
    fi

    token_response=$(curl -fsSL \
      --data-urlencode "grant_type=refresh_token" \
      --data-urlencode "client_id=ahwoo-client" \
      --data-urlencode "refresh_token=$KSA_REFRESH_TOKEN" \
      'https://auth.ahwoo.com/realms/ahwoo/protocol/openid-connect/token')

    access_token=$(echo "$token_response" | jq -r '.access_token')

    if [ -z "$access_token" ] || [ "$access_token" = "null" ]; then
      echo "KSA: token refresh failed — run 'nix run .#get-token' to get a fresh refresh token" >&2
      exit 1
    fi

    # 2. Get the pre-signed download URL for the latest Linux build
    signed_url=$(curl -fsSL \
      -H "Authorization: Bearer $access_token" \
      'https://api.ahwoo.com/games/0197f25e-1171-7476-944d-fdf8091a8edc/download/latest/linux' \
      | jq -r '.signedUrl')

    if [ -z "$signed_url" ] || [ "$signed_url" = "null" ]; then
      echo "KSA: failed to get signed download URL" >&2
      exit 1
    fi

    # 3. Download the tarball
    curl -fsSL -o "$out" "$signed_url"
  '';
}
