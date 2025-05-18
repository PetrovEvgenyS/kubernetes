# README

## Описание

Этот скрипт автоматизирует создание namespace, serviceaccount, роли и rolebinding в Kubernetes для CI/CD пайплайна (например, GitLab CI). Он позволяет быстро подготовить изолированное окружение с необходимыми правами для каждого проекта и среды.

## Использование

```bash
./setup.sh PROJECT_NAME ENVIRONMENT_NAME NAMESPACE
```

- `PROJECT_NAME` — уникальный идентификатор проекта (например, `myapp`)
- `ENVIRONMENT_NAME` — имя окружения (например, `dev`, `prod`)
- `NAMESPACE` — имя namespace, в котором будут созданы ресурсы

### Пример

```bash
./setup.sh myapp dev myapp-dev
```

## Что делает скрипт
1. Создаёт namespace, если он не существует
2. Создаёт serviceaccount для CI/CD
3. Создаёт роль с максимальными правами (см. ниже)
4. Привязывает роль к serviceaccount через rolebinding
5. Создаёт долгоживущий токен для serviceaccount и выводит его

## Описание роли (Role)

Роль, создаваемая скриптом, предоставляет максимальные права внутри указанного namespace. Она позволяет выполнять любые действия (`verbs: ["*"]`) над любыми ресурсами (`resources: ["*"]`) из следующих API-групп:

- `""` - основная группа (core API, например, pods, services, secrets, configmaps и др.)
- `"extensions"` - (устаревшая группа (в новых версиях Kubernetes почти не используется) например, ingress)
- `"apps"` - включает deployments, statefulsets, daemonsets
- `"batch"` - включает jobs и cronjobs
- `"events"` - доступ к событиям Kubernetes
- `"certmanager.k8s.io"` и `"cert-manager.io"` - для работы с сертификатами
- `"monitoring.coreos.com"` - для Prometheus Operator и мониторинга

Доступы:
- `Resources: ["*"]` - разрешает все ресурсы в указанных API-группах
- `Verbs: ["*"]` - разрешает все возможные действия (get, list, create, update, delete, watch, patch и др.)

**Пример YAML роли:**

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-<PROJECT_NAME>-<ENVIRONMENT_NAME>
  namespace: <NAMESPACE>
rules:
- apiGroups: ["", "extensions", "apps", "batch", "events", "certmanager.k8s.io", "cert-manager.io", "monitoring.coreos.com"]
  resources: ["*"]
  verbs: ["*"]
```

**Права роли:**
- Создавать, изменять, удалять, просматривать любые ресурсы в namespace
- Использовать все возможности, необходимые для CI/CD пайплайнов (развёртывание, управление секретами, сертификатами, мониторингом и т.д.)

## Важно
- Скрипт не проверяет существование ресурсов перед созданием, возможны ошибки при повторном запуске.
- Токен, получаемый в конце, можно использовать для доступа к Kubernetes API из CI/CD.

