MULTIVERSE=${1:-main}
[[ -z "$1" ]] && echo -n "Multiverse name not specified. "
echo "Using multiverse name \"${MULTIVERSE}\"." >&2

if [[ "$(whoami)" == "minecraft-server" ]]; then
    BASEDIR=${2:-/var/lib/minecraft}
else
    BASEDIR="${HOME}/.minecraft/servers"
fi

gjl_pwd="$BASEDIR/${MULTIVERSE}"

echo "Multiverse directory is ${gjl_pwd}." >&2
mkdir -p "${gjl_pwd}"
