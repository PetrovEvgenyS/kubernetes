# my-go-app Kubernetes Deployment

## Описание

Этот проект содержит манифесты Kubernetes для развертывания Go-приложения в namespace `app-namespace` с поддержкой Ingress.

## Состав

- `app-namespace.yaml` — пространство имён
- `app-deployment.yaml` — Deployment приложения
- `app-service.yaml` — Service для приложения
- `app-ingress.yaml` — Ingress для внешнего доступа

## Быстрый старт

1. Создайте namespace:
   ```sh
   kubectl apply -f app-namespace.yaml
   ```

2. Разверните приложение и сервис:
   ```sh
   kubectl apply -f app-deployment.yaml
   kubectl apply -f app-service.yaml
   ```

3. Настройте Ingress:
   ```sh
   kubectl apply -f app-ingress.yaml
   ```

4. Проверьте, что все ресурсы созданы:
   ```sh
   kubectl get all -n app-namespace
   ```

5. Добавьте в `/etc/hosts`:
   ```
   IP-address-k8s app.lan
   ```
   (или настройте DNS, если требуется)

6. Откройте приложение в браузере:  
   http://app.lan

## Удаление приложения

Для удаления всех ресурсов выполните:
```sh
kubectl delete -f app-ingress.yaml
kubectl delete -f app-service.yaml
kubectl delete -f app-deployment.yaml
kubectl delete -f app-namespace.yaml
```

## Примечания

- Для работы Ingress необходим установленный Ingress Controller (например, NGINX).
- Все ресурсы создаются в namespace `app-namespace`.
