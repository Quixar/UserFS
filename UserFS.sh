 #!/bin/bash

ROOT_DIR="ROOTDIR"
INTERVAL=30

mkdir -p "$ROOT_DIR"

while true; do
        active_users=$(who | cut -d" " -f1 | uniq)
        all_users=$(awk -F: '($3 >= 1000 && $1 != "nobody") {print $1}' /etc/passwd)
        for user in $all_users; do
                if echo "$active_users" | grep -q "^$user$"; then
                        user_dir="$ROOT_DIR/$user"
                        mkdir -p "$user_dir"
                        ps -u "$user" --no-header -o pid,cmd > "$user_dir/procs"
                        rm -f "$user_dir/lastlogin"
                else
                        user_dir="$ROOT_DIR/$user"
                        mkdir -p "$user_dir"
                        echo "" > "$user_dir/procs"
                        last_login=$(last -n 1 "$user")
                        echo "$last_login" > "$user_dir/lastlogin"
                fi
        done
        sleep $INTERVAL
done

