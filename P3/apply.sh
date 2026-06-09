#!/bin/bash

MODE=${1:-dynamic}
NO_FORMAT=$'\033[0m'
RED=$'\033[38;5;124m'
F_BOLD=$'\033[1m'
PURPLE=$'\033[38;5;105m'

if [[ "$MODE" != "static" && "$MODE" != "dynamic" ]]; then
    echo "${F_BOLD}${RED}[ERROR] Usage: $0 [static|dynamic]${NO_FORMAT}"
    exit 1
fi

running=$(docker ps -q)

if [[ -z "$running" ]]; then
    echo "${F_BOLD}${RED}[ERROR] No running containers${NO_FORMAT}"
    exit 1
fi

for cid in $running; do
    hostname=$(docker exec "$cid" hostname)

    id="${hostname##*-}"

    tmp="${hostname#*-}"
    type="${tmp%%-*}"

    case "$type" in
        router)
            cmd="./router/router-${id}-config-${MODE}.sh"
            ;;
        host)
            cmd="./host/host-${id}-config.sh"
            ;;
        *)
            echo "${F_BOLD}${PURPLE}[INFO] Skipping unknown container: $hostname${NO_FORMAT}"
            continue
            ;;
    esac

    echo "${F_BOLD}${PURPLE}[INFO] Applying $cmd to $hostname${NO_FORMAT}"

    if [[ ! -f "$cmd" ]]; then
        echo "${F_BOLD}${RED}[ERROR] Missing config file: $cmd${NO_FORMAT}"
        continue
    fi

    docker exec -i "$cid" sh < "$cmd"
done
