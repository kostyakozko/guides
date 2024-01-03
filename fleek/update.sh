#!/bin/bash

function stop_old {
  sudo systemctl stop lgtn  &>/dev/null
  sudo systemctl disable lgtn  &>/dev/null
  docker rm -f lightning-node  &>/dev/null
}

function env {
  user="lgtn"
  group="lgtn"
  source_dir="$HOME/.lightning/"
  destination_dir="/home/lgtn/.lightning/"
}

function add_user {
  useradd -m $user -s /bin/bash &>/dev/null
  sudo usermod -aG docker $user &>/dev/null
  sudo usermod -aG sudo $user &>/dev/null
  echo "$user ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers  &>/dev/null

}

function migrate_data {
  if [ -d "$source_dir" ]; then
    echo "✨ Wait 2 minutes...migrating data"
    sudo systemctl stop docker-lightning
    rm -rf "$destination_dir"
    cp -r "$source_dir" "$destination_dir"
  fi
  sudo systemctl restart docker-lightning
}


function install_docker {
  sudo -u $user bash -c 'bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/fleek/install_docker.sh)'
  sleep 10
}

function main {
  env
  stop_old
  add_user
  install_docker
  migrate_data
}

main