#!/bin/bash
#!/bin/bash

# Check if files exist
if [[ ! -f "ip.txt" || ! -f "pass.txt" ]]; then
    echo "Both ip.txt and pass.txt files must exist."
    exit 1
fi

# Read both files line by line
while IFS= read -r ip && IFS= read -r pass <&3; do
    # Perform action; in this example, print them.
    ssh -o "StrictHostKeyChecking no" root@$ip "PASSWD=$pass . <(wget -qO- https://raw.githubusercontent.com/kostyakozko/guides/main/shardeum/setup.sh) shardeum install"

done < ip.txt 3< pass.txt

