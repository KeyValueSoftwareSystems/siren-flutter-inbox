# This script creates/updates credentials.json file which is used
# to authorize publisher when publishing packages to pub.dev

# Checking whether the secrets are available as environment
# variables or not.
if [ -z "${INPUT_ACCESSTOKEN}" ]; then
  echo "Missing INPUT_ACCESSTOKEN environment variable"
  exit 1
fi

if [ -z "${INPUT_REFRESHTOKEN}" ]; then
  echo "Missing INPUT_REFRESHTOKEN environment variable"
  exit 1
fi

# Create credentials.json file.
  echo "Copy credentials"

  mkdir -p ~/.config/dart
    cat <<-EOF > ~/.config/dart/pub-credentials.json
    {
        "accessToken":"$INPUT_ACCESSTOKEN",
        "refreshToken":"$INPUT_REFRESHTOKEN",
        "tokenEndpoint":"https://accounts.google.com/o/oauth2/token",
        "scopes": [ "openid", "https://www.googleapis.com/auth/userinfo.email" ],
        "expiration": 1577149838000
    }
EOF