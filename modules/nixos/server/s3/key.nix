# Anything that needs to use s3 should store its basic config here
{
  rootCredentialsFile = "/nix/host/keys/minio/minio-credentials-full.env";
  nextcloud = {
    key = "nextcloud";
    secretFile = "/nix/host/keys/minio/keys/nextcloud/password.psk";
  };
}
