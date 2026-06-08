#!/bin/bash

MODE=${1:-dynamic}

if [[ "$MODE" != "static" && "$MODE" != "dynamic" ]]; then
    echo "Usage: $0 [static|dynamic]"
    exit 1
fi

running=$(docker ps -q)

if [[ -z "$running" ]]; then
    echo "No running containers"
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
            echo "Skipping unknown container: $hostname"
            continue
            ;;
    esac

    echo "Applying $cmd to $hostname"

    if [[ ! -f "$cmd" ]]; then
        echo "Missing config file: $cmd"
        continue
    fi

    docker exec -i "$cid" sh < "$cmd"
done