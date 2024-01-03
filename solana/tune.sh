#!/bin/bash

# Функция для установки параметра
set_param() {
    local param=$1
    local value=$2
    local file="/etc/sysctl.conf"

    # Проверяем, есть ли уже параметр в файле
    if grep -q "^${param}=" "$file"; then
        # Параметр найден, обновляем его значение
        sudo sed -i "s/^${param}=.*/${param}=${value}/" "$file"
    else
        # Параметра нет, добавляем его в конец файла
        echo "${param}=${value}" | sudo tee -a "$file" > /dev/null
    fi
}

# Устанавливаем параметры
set_param "vm.max_map_count" "1000000"
set_param "net.core.wmem_default" "134217728"
set_param "net.core.rmem_default" "134217728"
set_param "net.core.wmem_max" "134217728"
set_param "net.core.rmem_max" "134217728"
set_param "fs.nr_open" "1025000"
set_param "fs.file-max" "1025000"
set_param "net.core.optmem_max" "20480"

# Применяем изменения
sudo sysctl -p

sudo bash -c "cat >/etc/security/limits.d/90-solana-nofiles.conf <<EOF
# Increase process file descriptor count limit
* - nofile 1025000
EOF"

# bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/solana/sys_tuner.sh)