# Kubernetes: Services и Ingress

В этом репозитории представлены примеры манифестов для развертывания приложения с различными типами сервисов и Ingress в Kubernetes.

## Состав

- **ingress-v1.yaml** — Deployment, Service (ClusterIP) и Ingress для маршрутизации внешнего трафика через контроллер Ingress (nginx).
- **service-v1-NodePort.yaml** — Deployment и Service с типом NodePort для доступа к приложению через порт узла кластера.
- **service-v2-ClusterIP.yaml** — Deployment и Service с типом ClusterIP (доступ только внутри кластера).
- **service-v3-Loadbalancer.yaml** — Deployment и Service с типом LoadBalancer (создаёт внешний балансировщик нагрузки, если поддерживается кластером).

## Кратко о типах сервисов

- **ClusterIP** — сервис доступен только внутри кластера (по умолчанию).
- **NodePort** — сервис доступен снаружи кластера через определённый порт на каждом узле.
- **LoadBalancer** — сервис доступен снаружи через внешний балансировщик нагрузки.
- **Ingress** — объект для маршрутизации HTTP/HTTPS-трафика к сервисам внутри кластера по доменным именам и путям.

## Применение

1. Примените нужный манифест:
   ```sh
   kubectl apply -f service-v1-NodePort.yaml
   # или
   kubectl apply -f service-v2-ClusterIP.yaml
   # или
   kubectl apply -f service-v3-Loadbalancer.yaml
   # или
   kubectl apply -f ingress-v1.yaml
   ```
2. Для Ingress убедитесь, что установлен контроллер Ingress (например, nginx-ingress).

3. Для доступа к приложению:
   - **NodePort**: `http://<NodeIP>:31200`
   - **LoadBalancer**: внешний IP, выданный балансировщиком
   - **Ingress**: настройте DNS или hosts на домен `app.lan` и обращайтесь по `http://app.lan`

## Примечания
- Все сервисы используют один и тот же Deployment с приложением на базе образа `petrovevgeny/my-php-app:v1.0`.
- Для Ingress требуется отдельная установка контроллера (например, nginx).
