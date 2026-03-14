# Kubernetes Deployment, Service и HPA

В каталоге приведены примеры манифестов Kubernetes для запуска PHP-приложения, публикации его через `Service` и автоматического масштабирования через `HorizontalPodAutoscaler` (HPA).

## Файлы
- `deployment-v1.yaml` — базовый пример `Deployment` + `Service` с подробными комментариями.
- `deployment-v2.yaml` — расширенный пример:
  - `Deployment` c `replicas: 3`
  - `Service` типа `NodePort`
  - `HorizontalPodAutoscaler` (`autoscaling/v2`) с масштабированием по `cpu` и `memory`

## Быстрый старт
1. Примените расширенный манифест:
   ```sh
   kubectl apply -f deployment-v2.yaml
   ```
2. Проверьте ресурсы:
   ```sh
   kubectl get deploy
   kubectl get svc
   kubectl get hpa
   ```
3. Проверьте детали HPA:
   ```sh
   kubectl describe hpa my-web-deployment-hpa
   ```
4. Доступ к приложению: `http://<NodeIP>:31200`.

## Ключевые параметры в `deployment-v2.yaml`
- `Deployment`:
  - начальное количество реплик: `3`
  - `requests`: `cpu: 200m`, `memory: 128Mi`
  - `limits`: `cpu: 500m`, `memory: 256Mi`
- `HPA`:
  - `minReplicas: 3`
  - `maxReplicas: 10`
  - цели масштабирования:
    - CPU: `averageUtilization: 70`
    - Memory: `averageUtilization: 80`

## Важно
Для работы HPA по resource-метрикам в кластере должен быть установлен `metrics-server` (официальная документация Kubernetes):
https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/

Подробные пояснения по полям см. в комментариях внутри `deployment-v1.yaml` и `deployment-v2.yaml`.
