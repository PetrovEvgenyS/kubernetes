#!/bin/bash

### Определение цветовых кодов ###
ESC=$(printf '\033') RESET="${ESC}[0m"
MAGENTA="${ESC}[35m"

### Цветная функция для вывода ###
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }

### Определение ОС и менеджера пакетов ###
detect_os() {
    if [ ! -f /etc/os-release ]; then
        echo "Не найден /etc/os-release. Невозможно определить ОС."
        exit 1
    fi

    # shellcheck disable=SC1091
    . /etc/os-release
    OS_ID="${ID:-unknown}"
    if [ "$OS_ID" = "debian" ]; then
        PKG_MANAGER="apt"
    elif [ "$OS_ID" = "almalinux" ]; then
        PKG_MANAGER="dnf"
    else
        echo "ОС не поддерживается: $OS_ID. Поддерживаются только debian и almalinux."
        exit 1
    fi
}


### Функция обновления системы ###
update_system() {
    magentaprint "Обновляем систему..."
    if [ "$PKG_MANAGER" = "apt" ]; then
        apt update -y
    else
        # Отключить репозитории:
        #dnf config-manager --set-disabled extras crb
        dnf makecache -y
    fi
}


### Установка базовых зависимостей ###
install_dependencies() {
    magentaprint "Устанавливаем базовые зависимости..."
    if [ "$PKG_MANAGER" = "apt" ]; then
        apt install -y curl ca-certificates
    else
        dnf install -y curl ca-certificates
    fi
}


### Функция отключения SELinux ###
disable_selinux() {
    if [ "$PKG_MANAGER" = "apt" ]; then
        magentaprint "SELinux для Debian не настраиваем. Пропускаем шаг."
        return
    fi

    if [ ! -f /etc/selinux/config ]; then
        magentaprint "Файл конфигурации SELinux не найден."
        return
    fi
    if grep -q '^SELINUX=permissive' /etc/selinux/config; then
        magentaprint "SELinux уже в режиме permissive. Пропускаем."
        return
    fi
    magentaprint "Отключаем SELinux..."
    sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
    magentaprint "SELinux отключен. Перезагрузите систему для применения изменений."
# Enforcing (Принудительный): Политики SELinux применяются, и доступ, который не разрешен политиками, блокируется.
# Permissive (Разрешающий): Политики SELinux не блокируют доступ, но все нарушения регистрируются в логах. Этот режим полезен для отладки и настройки.
# Disabled (Отключен): SELinux полностью отключен.
}


### Функция отключения SWAP ###
disable_swap() {
    magentaprint "Отключаем swap..."
    swapoff -a
    sed -i '/swap/d' /etc/fstab
}


### Функция настройки sysctl для Kubernetes ###
configure_sysctl() {
    magentaprint "Настраиваем sysctl для Kubernetes..."
    cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
    sysctl --system
}

### Функция установки kubectl ###
install_kubectl() {
    if command -v kubectl &>/dev/null; then
        magentaprint "kubectl уже установлен: $(kubectl version --client)"
        return
    fi
    magentaprint "Устанавливаем kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl
    kubectl version --client
}


### Функция установки Minikube ###
install_minikube() {
    if command -v minikube &>/dev/null; then
        magentaprint "minikube уже установлен: $(minikube version)"
        return
    fi
    magentaprint "Устанавливаем Minikube..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    install -o root -g root -m 0755 minikube /usr/local/bin/minikube
    rm -f minikube
    minikube version
}


### Главная функция ###
main() {
    detect_os
    update_system
    install_dependencies
    disable_selinux
    disable_swap
    configure_sysctl
    install_kubectl
    install_minikube
    magentaprint "kubectl и minikube установлены. Установка завершена."
}

### Запуск основной функции ###
main