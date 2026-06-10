#!/bin/bash

running=$(docker ps -q)

if [[ -z "$running" ]]; then
    echo "[ERROR] No running containers"
    exit 1
fi

apply_config() {
    local cid="$1"

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
            return
            ;;
    esac

    echo "[INFO] Applying $cmd to $hostname"

    [[ ! -f "$cmd" ]] && {
        echo "[ERROR] Missing config file: $cmd"
        return
    }

    cat "$cmd" | docker exec -i "$cid" sh

    if [[ $? -eq 0 ]]; then
        echo "[SUCCESS] Applied $cmd to $hostname"
    else
        echo "[ERROR] Failed applying $cmd to $hostname"
    fi
}

echo "[INFO] Configuring Route Reflectors first..."

for cid in $running; do
    hostname=$(docker exec "$cid" hostname)

    if [[ "$hostname" == badass-rr-* ]]; then
        apply_config "$cid"
    fi
done
sleep 5
echo "[INFO] Configuring remaining nodes..."

for cid in $running; do
    hostname=$(docker exec "$cid" hostname)

    if [[ "$hostname" != badass-rr-* ]]; then
        apply_config "$cid"
    fi
done