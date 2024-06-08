#!/bin/bash

function validate_username() {
    local username=$1
    if [[ ${#username} -lt 1 || ${#username} -gt 30 ]]; then
        echo "Помилка: ім'я користувача повинно містити від 1 до 30 символів."
        return 1
    fi
    if ! [[ $username =~ ^[a-zA-Z\ ]+$ ]]; then
        echo "Помилка: ім'я користувача повинно містити лише літери та пробіли."
        return 1
    fi
    return 0
}

function validate_password() {
    local password=$1
    if [[ ${#password} -lt 8 || ${#password} -gt 20 ]]; then
        echo "Помилка: пароль повинен містити від 8 до 20 символів."
        return 1
    fi
    if ! [[ $password =~ [0-9] ]]; then
        echo "Помилка: пароль повинен містити хоча б одну цифру."
        return 1
    fi
    if ! [[ $password =~ [a-z] ]]; then
        echo "Помилка: пароль повинен містити хоча б одну малу літеру."
        return 1
    fi
    if ! [[ $password =~ [A-Z] ]]; then
        echo "Помилка: пароль повинен містити хоча б одну велику літеру."
        return 1
    fi
    if ! [[ $password =~ [\!\@\#\$\%\^\&\*\(\)_\+] ]]; then
        echo "Помилка: пароль повинен містити хоча б один спеціальний символ (!@#$%^&*()_+)."
        return 1
    fi
    echo "Вимоги до пароля:"
    echo "- Довжина від 8 до 20 символів"
    echo "- Хоча б одна цифра"
    echo "- Хоча б одна мала літера"
    echo "- Хоча б одна велика літера"
    echo "- Хоча б один спеціальний символ (!@#$%^&*()_+)"
    return 0
}

while true; do
    read -p "Введіть ім'я нового користувача (або 'q' для виходу): " username
    if [[ $username == "q" ]]; then
        break
    fi

    if validate_username "$username"; then
        if id "$username" &>/dev/null; then
            echo "Користувач $username вже існує."
        else
            while true; do
                read -p "Введіть пароль для користувача $username: " password
                if validate_password "$password"; then
                    useradd -m -s /bin/bash "$username"
                    if [[ $? -eq 0 ]]; then
                        echo "$username:$password" | chpasswd
                        if [[ $? -eq 0 ]]; then
                            echo "Користувач $username успішно створений."
                        else
                            echo "Помилка при встановленні пароля для користувача $username."
                            userdel -r "$username"  # Видалення користувача, якщо встановлення пароля не вдалося
                        fi
                    else
                        echo "Помилка при створенні користувача $username."
                    fi
                    break
                fi
            done
        fi
    fi
done