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

(
    cd "${gjl_pwd}"
    [[ -f "server.properties" ]] || exit

    level_name=$(sed -n "s/^level-name=//p" "server.properties")

    for D in "nether -1" "the_end 1"; do
        TYPE="${D% *}"
        DIM="DIM${D#* }"

        if [[ -d "${level_name}" && -d "${level_name}_${TYPE}/${DIM}" ]]; then
            echo -n "CraftBukkit ${TYPE} detected, " >&2

            if [[ -d "${level_name}/${DIM}" && ! -L "${level_name}/${DIM}" ]]; then
                echo "but a conflicting ${TYPE} is already present! Ignoring." >&2
            else
                echo "symlinking for the official server." >&2
                ln -snf "../${level_name}_${TYPE}/${DIM}" "${level_name}/${DIM}"
            fi
        fi
    done
)
