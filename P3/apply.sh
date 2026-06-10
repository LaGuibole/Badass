#!/bin/bash

running=$(docker ps -q)

if [[ -z "$running" ]]; then
    echo "[ERROR] No running containers"
    exit 1
fi

for cid in $running; do
    hostname=$(docker exec "$cid" hostname)

    id="${hostname##*-}"

    tmp="${hostname#*-}"
    type="${tmp%%-*}"

    case "$type" in
        rr)
            cmd="./router/rr-${id}-config.sh"
            ;;
        router)
            cmd="./router/router-${id}-config.sh"
            ;;
        host)
            cmd="./host/host-${id}-config.sh"
            ;;
        *)
            echo "[INFO] Skipping unknown container: $hostname"
            continue
            ;;
    esac

    echo "[INFO] Applying $cmd to $hostname"

    if [[ ! -f "$cmd" ]]; then
        echo "[ERROR] Missing config file: $cmd"
        continue
    fi

    docker exec -i "$cid" sh < "$cmd"

    if [[ $? -eq 0 ]]; then
        echo "[SUCCESS] Applied $cmd to $hostname"
    else
        echo "[ERROR] Failed applying $cmd to $hostname"
    fi
done
