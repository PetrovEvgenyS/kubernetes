# my-go-app Helm Chart

## Описание

Helm-чарт для развертывания Go-приложения в Kubernetes с поддержкой Service и Ingress. Все параметры настраиваются через values.yaml.

## Структура

- `Chart.yaml` — описание Helm-чарта
- `values.yaml` — значения по умолчанию для параметров
- `templates/` — шаблоны манифестов Kubernetes:
  - `app-namespace.yaml` — Namespace
  - `app-deployment.yaml` — Deployment
  - `app-service.yaml` — Service
  - `app-ingress.yaml` — Ingress
  - `NOTES.txt` — подсказки после установки

## Быстрый старт

1. Установите Helm (https://helm.sh/)

2. Перейдите в директорию с чартом:
   ```sh
   cd my-go-app-chart
   ```

3. Установите чарт в кластер:
   ```sh
   helm install my-go-app .
   ```
   По умолчанию будет создан namespace `app-namespace` и все ресурсы внутри него.

4. Проверьте развертывание:
   ```sh
   kubectl get all -n app-namespace
   ```

5. Добавьте в `/etc/hosts` (или настройте DNS):
   ```
   IP-address-k8s app.lan
   ```

6. Откройте приложение в браузере:  
   http://app.lan

## Кастомизация

Вы можете изменить параметры в файле `values.yaml` или передать их через флаги `--set` при установке.

## Базовые команды Helm

- Просмотреть список релизов:
  ```sh
  helm list
  ```
- Просмотреть релизы в определённом namespace:
  ```sh
  helm list -n app-namespace
  ```
- Обновить релиз (например, после изменения values.yaml):
  ```sh
  helm upgrade my-go-app .
  ```
- Просмотреть историю релиза:
  ```sh
  helm history my-go-app
  ```
- Удалить релиз (удаления всех ресурсов):
  ```sh
  helm uninstall my-go-app
  ```
