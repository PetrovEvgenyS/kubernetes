# Установка kubectl и Minikube на AlmaLinux/Ubuntu

Скрипт `setup.sh` автоматизирует подготовку хоста и установку `kubectl` и `minikube` на:
- AlmaLinux (и совместимые RHEL-дистрибутивы)
- Ubuntu (и совместимые Debian-дистрибутивы)

## Шаги, выполняемые скриптом
- Определение ОС и менеджера пакетов (`dnf`/`apt`)
- Установка базовых зависимостей (`curl`, `ca-certificates`)
- Обновление системы
- Отключение SELinux (только для AlmaLinux/RHEL)
- Отключение swap
- Настройка sysctl для Kubernetes
- Установка kubectl
- Установка Minikube

## Запуск Minikube вручную
Пример:

```bash
minikube start --driver=docker
```

Список доступных драйверов и рекомендации:  
[Документация Minikube — Drivers](https://minikube.sigs.k8s.io/docs/drivers/)

## Примечания
- После отключения SELinux может потребоваться перезагрузка.
