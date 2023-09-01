#!/bin/bash

node=$1
option=$2

main="https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh"
docker="https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh"
install="https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh"
expecter="https://raw.githubusercontent.com/kostyakozko/guides/main/shardeum/script.exp"
healthcheck="https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/shardeum/health.sh"
unstake="https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/shardeum/unstake.sh"
stake="https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/shardeum/stake.sh"

confirm=1

# Show the main menu
if [ "$option" = "install" ]; then
    if [ -z "$PASSWD" ]; then
        echo "Dashboard password is not specified\n"
        exit 1
    fi
    if [ "$confirm" != "0" ]; then
        echo "\$nrconf{kernelhints} = 0;" > /etc/needrestart/conf.d/silence_kernel.confirm
        apt update -y
        apt install expect -y
        . <(wget -qO- $main) &>/dev/null
        . <(wget -qO- $docker) &>/dev/null
        wget -O installer.sh $install
        chmod +x installer.sh
        wget -O script.exp $expecter
        chmod +x script.exp
        PASSW=$PASSWD ./script.exp
        source $HOME/.shardeum/.env
        cd $HOME
        echo "The installation of $node with option $option was successful! Stake your tokens in node: https://$SERVERIP:$DASHPORT/maintenance"
    fi
elif [ "$option" = "healthcheck" ]; then
    if [ "$confirm" != "0" ]; then
        tmux new-session -d -s shardeum_healthcheck '. <(wget -qO- $healthcheck)'
        cd $HOME
        echo "Healthcheck enabled for $node was successful!"
    fi
elif [ "$option" = "unstake" ]; then
    if [ "$confirm" != "0" ]; then
        . <(wget -qO- $unstake)
        cd $HOME
        echo "Force unstake for $node was successful!"
    fi
elif [ "$option" = "stake" ]; then
    if [ "$confirm" != "0" ]; then
        . <(wget -qO- $stake)
        cd $HOME
        echo "Stake for $node was successful!"
    fi
elif [ "$option" = "delete" ]; then
    if [ "$confirm" != "0" ]; then
        cd $HOME/.shardeum && ./cleanup.sh &>/dev/null
        cd $HOME && rm -rf $HOME/.shardeum/
        echo "$node was successful deleted!"
    fi
else
    echo "The installation was cancelled."
fi
