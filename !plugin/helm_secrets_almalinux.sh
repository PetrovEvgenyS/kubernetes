#!/bin/bash

### Определение цветовых кодов ###
ESC=$(printf '\033') RESET="${ESC}[0m"
MAGENTA="${ESC}[35m" GREEN="${ESC}[32m"

### Цветная функция для вывода ###
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }
greenprint() { printf "${GREEN}%s${RESET}\n" "$1"; }

# ----------------------------------------------------------------------- #

# Функция установки Helm Secrets и всего необходимого
install_helm_secrets() {
    magentaprint "Запускаем установку Helm Secrets..."

    magentaprint "Обновление системы и установка зависимостей: wget git gnupg2 pinentry"
    sudo dnf update -y
    sudo dnf install -y wget git gnupg2 pinentry
    greenprint "gnupg2 — для работы с GPG-ключами."

    magentaprint "Устанавливаем Helm Secrets..."
    helm plugin install https://github.com/jkroepke/helm-secrets --version v4.6.3
    greenprint "helm plugin list:"
    greenprint "$(helm plugin list)"
      
    magentaprint "Устанавливаем SOPS..."
    wget https://github.com/getsops/sops/releases/download/v3.9.4/sops-v3.9.4.linux.amd64 -O /usr/local/bin/sops
    sudo chmod +x /usr/local/bin/sops
    greenprint "sops --version:"
    greenprint "$(sops --version)"

    magentaprint "Настраиваем GPG_TTY..."
    export GPG_TTY=$(tty)
    echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
    source ~/.bashrc

    magentaprint "Генерируем GPG-ключ Ed25519..."
    gpg --batch --generate-key <<EOF
%echo Generating an Ed25519 key
Key-Type: EdDSA
Key-Curve: Ed25519
Subkey-Type: ECDH
Subkey-Curve: cv25519
Name-Real: Evgen
Name-Email: test@example.com
Expire-Date: 0
%no-protection
%commit
%echo Done
EOF

    magentaprint "Получение fingerprint"
    FINGERPRINT=$(gpg --fingerprint "Evgen" | sed -n '/pub/{n;s/ //g;p;q}' | grep -o '[0-9A-F]\{40\}')
    if [ -z "$FINGERPRINT" ]; then
        magentaprint "Ошибка: не удалось найти GPG-ключ для Evgen."
        exit 1
    fi
    magentaprint "Fingerprint ключа: $FINGERPRINT"

    magentaprint "Создаём secrets.yaml..."
    cat > secrets.yaml <<EOF
secret:
  db: "demo"
  user: "demo"
  password: "demo"
EOF

    magentaprint "Создаём .sops.yaml..."
    cat > .sops.yaml <<EOF
creation_rules:
  - path_regex: \.yaml\$
    pgp: "$FINGERPRINT"
EOF

    magentaprint "Шифруем secrets.yaml..."
    helm secrets encrypt secrets.yaml > secrets.enc.yaml
    magentaprint "Содержимое secrets.enc.yaml:"
    cat secrets.enc.yaml

    magentaprint "Результат расшифровки:"
    helm secrets decrypt secrets.enc.yaml
    echo " "
    magentaprint "Установка завершена."
}

# Функция удаления всего
remove_helm_secrets() {
    magentaprint "Запускаем очистку Helm Secrets..."

    magentaprint "Удаляем Helm Secrets..."
    helm plugin uninstall secrets 2>/dev/null || magentaprint "Плагин уже удалён или не установлен."

    magentaprint "Удаляем SOPS..."
    sudo rm -f /usr/local/bin/sops

    magentaprint "Удаляем файлы секретов и конфигурацию SOPS..."
    rm -f secrets.yaml secrets.enc.yaml .sops.yaml

    magentaprint "Удаляем GPG-ключи..."
    FINGERPRINT=$(gpg --fingerprint "Evgen" | sed -n '/pub/{n;s/ //g;p;q}' | grep -o '[0-9A-F]\{40\}')
    if [ -n "$FINGERPRINT" ]; then
        gpg --batch --yes --delete-secret-keys "$FINGERPRINT" || { magentaprint "Ошибка удаления секретного ключа"; exit 1; }
        gpg --batch --yes --delete-keys "$FINGERPRINT" || { magentaprint "Ошибка удаления публичного ключа"; exit 1; }
        magentaprint "Ключ с fingerprint $FINGERPRINT удалён."
    else
        magentaprint "Ключ GPG для Evgen не найден."
    fi

    magentaprint "Удаляем GPG_TTY из ~/.bashrc..."
    sed -i '/export GPG_TTY=$(tty)/d' ~/.bashrc
    source ~/.bashrc

    magentaprint "Удаляем GPG-конфигурацию..."
    rm -rf ~/.gnupg

    magentaprint "Удаляем установленные пакеты..."
    sudo dnf remove -y wget git gnupg2 pinentry
    sudo dnf autoremove -y

    magentaprint "Очистка завершена."
}

# Проверка аргументов и вызов функции
case "$1" in
    "install") install_helm_secrets ;;
    "remove") remove_helm_secrets ;;
    *)
        magentaprint "Использование: $0 {install|remove}"
        magentaprint "  install - Установить Helm Secrets и всё необходимое."
        magentaprint "  remove - Удалить всё, установленное для Helm Secrets."
        echo " "
        greenprint "  Cкрипт для установки или удаления плагина helm secrets на almalinux."
        exit 1 ;;
esac
