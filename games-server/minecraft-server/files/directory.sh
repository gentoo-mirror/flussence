# Usage: minecraft-server-<$version> [$directory]
# $directory may either be an existing directory path or a basename; if the
# latter then the rest will be filled in based on the running user.

SERVER_NAME=${1:-main}
[[ -z "$1" ]] && echo "Using default server name '$SERVER_NAME'."

mc_uid='minecraft-server'

if [[ -d "$SERVER_NAME" ]]; then
    gjl_pwd=$SERVER_NAME
elif [[ "$(whoami)" == "$mc_uid" ]]; then
    gjl_pwd="$HOME/$SERVER_NAME"
    err_cmd="# install -m 0750 -o $mc_uid -g $(id -ng $mc_uid) -d '$gjl_pwd'"
else
    gjl_pwd="$HOME/.minecraft/servers/$SERVER_NAME"
    err_cmd="$ mkdir -p '$gjl_pwd'"
fi

echo "Server data directory set to '$gjl_pwd'."

if [[ ! -d "$gjl_pwd" ]]; then
    echo
    echo "ERROR: Data directory does not exist."
    echo "This launcher script will not create it automatically for security"
    echo "reasons. You can do it manually using the following command, but"
    echo "verify its sanity first:"
    echo "$err_cmd"
    echo
    echo "Remember that newer versions of the server will not run until after"
    echo "you manually accept the EULA, which it writes to the data directory."
    exit 1
fi

