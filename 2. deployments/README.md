# Описание Kubernetes Deployment и Service

Этот репозиторий содержит пример манифеста Kubernetes для развертывания PHP-приложения с помощью Deployment и публикации его через Service.

## Файлы
- `deployment-v1.yaml` — основной манифест, описывающий:
  - Deployment с 3 репликами контейнера `petrovevgeny/my-php-app:v1.0`.
  - Ограничения и запросы ресурсов для контейнера.
  - Service типа NodePort для проброса порта приложения наружу.

## Быстрый старт
1. Примените манифест:
   ```sh
   kubectl apply -f deployment-v1.yaml
   ```
2. Проверьте статус ресурсов:
   ```sh
   kubectl get pods
   kubectl get svc
   ```
3. Доступ к приложению осуществляется через NodePort (например, `http://<NodeIP>:31200`).

## Структура
- Deployment:
  - 3 реплики
  - Метки: `env: prod`, `app: main`, `owner: Evgeny`
  - Ограничения ресурсов: 128M памяти, 0.5 CPU
- Service:
  - Тип: NodePort
  - Внешний порт: 31200
  - Внутренний порт приложения: 80

---

Для подробностей смотрите комментарии внутри `deployment-v1.yaml`.
