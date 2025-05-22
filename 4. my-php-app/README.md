# my-php-app Kubernetes Deployment

## Описание

Этот проект содержит манифесты Kubernetes для развертывания PHP-приложения с базой данных PostgreSQL. Все ресурсы размещаются в пространстве имён `app-namespace`.

## Состав
- **app-namespace.yaml** — пространство имён
- **app-deployment.yaml** — деплоймент PHP-приложения
- **app-service.yaml** — сервис для приложения
- **app-ingress.yaml** — Ingress для внешнего доступа
- **postgres-deployment.yaml** — деплоймент PostgreSQL
- **postgres-service.yaml** — сервис для PostgreSQL
- **postgres-pvc.yaml** — хранилище для PostgreSQL
- **postgres-secret.yaml** — секреты для БД (имя, пользователь, пароль)
- **postgres-configmap.yaml** — SQL-скрипт инициализации

## Быстрый старт
1. Создайте namespace:
   ```sh
   kubectl apply -f app-namespace.yaml
   ```
2. Создайте секреты и ConfigMap:
   ```sh
   kubectl apply -f postgres-secret.yaml
   kubectl apply -f postgres-configmap.yaml
   ```
3. Создайте PVC и разверните PostgreSQL:
   ```sh
   kubectl apply -f postgres-pvc.yaml
   kubectl apply -f postgres-deployment.yaml
   kubectl apply -f postgres-service.yaml
   ```
4. Разверните приложение:
   ```sh
   kubectl apply -f app-deployment.yaml
   kubectl apply -f app-service.yaml
   ```
5. Настройте Ingress:
   ```sh
   kubectl apply -f app-ingress.yaml
   ```

## Доступ
- Приложение будет доступно по адресу http://app.lan (настройте DNS или hosts).

## Примечания
- Для работы Ingress необходим установленный Ingress Controller (например, NGINX).
- Все ресурсы создаются в namespace `app-namespace`.
