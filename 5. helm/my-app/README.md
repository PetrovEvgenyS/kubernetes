# my-app Helm Chart

## Описание
Helm chart для деплоя PHP-приложения и PostgreSQL в Kubernetes.

## Быстрый старт

Установите чарт:
```bash
helm secrets install my-app ./my-app -f ./my-app/secrets.enc.yaml
```

## Структура чарта

- `templates/` — шаблоны Kubernetes-манифестов
- `values.yaml` — значения по умолчанию (переменные)
- `secrets.enc.yaml` — зашифрованные секреты (sops)
- `Chart.yaml` — метаинформация чарта

## Пример удаления
```bash
helm uninstall my-app -n <namespace>
```
