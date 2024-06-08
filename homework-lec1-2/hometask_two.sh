#!/bin/bash

# Скрипт №2
# Написати універсальний скрипт на bash для Ubuntu та CentOS, який має назви пакетів в якості агрументів та встановлювати їх в ОС використовуючи відповідний пакетний менеджер. Використовуйте цикли і перевірки вводу від користувача.
# Наприклад:
# deployer.sh nginx

# Перевірка операційної системи
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Визначення дистрибутиву Linux
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
    else
        OS=$(uname -s)
    fi

    # Перевірка, чи є аргументи
    if [ $# -eq 0 ]; then
        echo "Будь ласка, вкажіть назви пакетів для встановлення."
        exit 1
    fi

    # Встановлення пакетів в залежності від дистрибутиву
    if [[ $OS == "Ubuntu"* ]]; then
        sudo apt update
        for package in "$@"; do
            sudo apt install -y "$package"
        done
    elif [[ $OS == "CentOS Linux" ]]; then
        for package in "$@"; do
            sudo yum install -y "$package"
        done
    else
        echo "Цей скрипт написаний тільки для Ubuntu та CentOS. Будь ласка, спробуйте запустити скрипт на цих версіях ОС."
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Фіга, мажор у чаті, техніка у нього з яблучком, ти диви. Ставь Лінух, будь як усі."
    exit 1
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo "Вінда - форева! Але давай все ж мучатись на Лінуксі."
    exit 1
else
    echo "Невідома операційна система. Скрипт писав так собі пес-девопс, тож підтримує тільки Ubuntu та CentOS."
    exit 1
fi