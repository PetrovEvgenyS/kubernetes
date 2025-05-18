#!/bin/bash

# Скрипт для автоматизации создания namespace, serviceaccount, роли и rolebinding в Kubernetes
# для CI/CD/CD пайплайна GitLab. Используется для настройки окружения под каждый проект и среду.

PROJECT_NAME=$1         # Уникальный идентификатор проекта
ENVIRONMENT_NAME=$2     # Имя окружения
NAMESPACE=$3            # Имя namespace
SERVICEACCOUNT=serviceaccount-$PROJECT_NAME-$ENVIRONMENT_NAME   # Имя serviceaccount
ROLE=role-$PROJECT_NAME-$ENVIRONMENT_NAME                       # Имя role
ROLEBINDING=rolebinding-$PROJECT_NAME-$ENVIRONMENT_NAME         # Имя rolebinding

# Цвета для вывода в терминал
GREEN='\033[0;32m'
NC='\033[0m'

# Проверяем, что все параметры переданы
if [ -n "$PROJECT_NAME" ] && [ -n "$ENVIRONMENT_NAME" ] && [ -n "$NAMESPACE" ]; then
    # Создание namespace для проекта и окружения
    echo -e "${GREEN}creating namespace for project${NC}"
    kubectl create namespace $NAMESPACE

    echo
    # Создание serviceaccount для CI/CD в этом namespace
    echo -e "${GREEN}creating CI/CD serviceaccount for project${NC}"
    kubectl create serviceaccount $SERVICEACCOUNT --namespace $NAMESPACE

    echo
    # Создание роли с максимальными правами для CI/CD
    echo -e "${GREEN}creating CI/CD role for project${NC}"
    cat << EOF | kubectl create --namespace $NAMESPACE -f -
        apiVersion: rbac.authorization.k8s.io/v1
        kind: Role
        metadata:
          name: $ROLE
          namespace: $NAMESPACE
        rules:
        - apiGroups: ["", "extensions", "apps", "batch", "events", "certmanager.k8s.io", "cert-manager.io", "monitoring.coreos.com"]
          resources: ["*"]
          verbs: ["*"]
EOF

    echo
    # Привязка роли к serviceaccount
    echo -e "${GREEN}creating CI/CD rolebinding for project${NC}"
    kubectl create rolebinding $ROLEBINDING \
        --namespace $NAMESPACE \
        --serviceaccount $NAMESPACE:$SERVICEACCOUNT \
        --role $ROLE

    echo
    # Создание долгоживущего токена (Kubernetes 1.24+)
    echo -e "${GREEN}Creating long-lived token for CI/CD...${NC}"
    cat <<EOF | kubectl apply --namespace "$NAMESPACE" -f -
    apiVersion: v1
    kind: Secret
    metadata:
      name: $SERVICEACCOUNT-token
      namespace: $NAMESPACE
      annotations:
        kubernetes.io/service-account.name: $SERVICEACCOUNT
    type: kubernetes.io/service-account-token
EOF

    echo
    # Получение токена
    echo -e "${GREEN}Access token for CI/CD (long-lived):${NC}"
    kubectl get secret $SERVICEACCOUNT-token \
        --namespace "$NAMESPACE" \
        -o jsonpath='{.data.token}' | base64 -d
    echo
    echo  # Пустая строка после токена
else
    # Если параметры не переданы, выводим
    echo "Usage: $0 PROJECT_NAME ENVIRONMENT_NAME NAMESPACE"
fi
