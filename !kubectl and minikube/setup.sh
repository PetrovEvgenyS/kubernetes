#!/bin/bash

### Определение цветовых кодов ###
ESC=$(printf '\033') RESET="${ESC}[0m"
MAGENTA="${ESC}[35m"

### Цветная функция для вывода ###
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }


### Функция обновления системы ###
update_system() {
    magentaprint "Обновляем систему..."
    dnf update -y
}

### Функция отключения SELinux ###
disable_selinux() {
    magentaprint "Отключаем SELinux..."
    if [ -f /etc/selinux/config ]; then
        sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config  
        magentaprint "SELinux отключен. Перезагрузите систему для применения изменений."
    else
        magentaprint "Файл конфигурации SELinux не найден."
    fi
# Enforcing (Принудительный): Политики SELinux применяются, и до-ступ, который не разрешен политиками, блокируется.
# Permissive (Разрешающий): Политики SELinux не блокируют доступ, но все нарушения регистрируются в логах. Этот режим полезен для отлад-ки и настройки.
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
    magentaprint "Устанавливаем kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl
    kubectl version --client
}


### Функция установки Minikube ###
install_minikube() {
    magentaprint "Устанавливаем Minikube..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    install minikube /usr/local/bin/minikube
    rm -f minikube
    minikube version
}


### Функция запуска Minikube ###
start_minikube() {
    magentaprint "Запускаем Minikube..."
    minikube start --driver=kvm2
}


### Главная функция ###
main() {
    update_system
    disable_selinux
    disable_swap
    configure_sysctl
    install_kubectl
    install_minikube
    start_minikube
    magentaprint "Установка завершена!"
}

### Запуск основной функции ###
main
