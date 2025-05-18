# Kubernetes: Примеры Pod и Service

## Описание

В этом каталоге представлены примеры YAML-манифестов для развертывания Pod и Service в Kubernetes.

## Структура

- **0. example.yaml**  — пример Pod с контейнером nginx и подробными комментариями.
- **1. my-php-app.yaml**  — Pod с приложением на PHP (`petrovevgeny/my-php-app:v1.0`).
- **2. my-php-app-v1 and service.yaml**  — Pod с приложением на PHP и сервисом типа NodePort для доступа к приложению извне кластера.

## Быстрый старт

1. Примените нужный манифест:

   ```sh
   kubectl apply -f "0. example.yaml"
   kubectl apply -f "1. my-php-app.yaml"
   kubectl apply -f "2. my-php-app-v1 and service.yaml"
   ```

2. Для доступа к приложению через NodePort используйте IP-адрес любого узла кластера и порт 31200:

   ```
   http://<NODE_IP>:31200
   ```
