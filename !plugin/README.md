# Описание скриптов

## helm_secrets_almalinux.sh

Скрипт для установки или удаления плагина Helm Secrets на AlmaLinux.

**Возможности:**
- Установка зависимостей (wget, git, gnupg2, pinentry)
- Установка плагина Helm Secrets и SOPS
- Генерация GPG-ключа (Ed25519) для шифрования секретов
- Создание примера секрета (secrets.yaml) и конфигурации SOPS (.sops.yaml)
- Шифрование секрета и демонстрация расшифровки
- Удаление всех установленных компонентов и ключей

**Использование:**
```
./helm_secrets_almalinux.sh install   # Установить всё необходимое
./helm_secrets_almalinux.sh remove    # Удалить всё, что было установлено
```

---

## gpg_export_import.sh

Скрипт для экспорта и импорта приватного GPG-ключа.

**Возможности:**
- Экспорт приватного ключа по fingerprint, имени или email в файл private-key.asc
- Импорт приватного ключа из файла

**Использование:**
```
./gpg_export_import.sh export [key-id]      # Экспортировать приватный ключ (можно без key-id)
./gpg_export_import.sh import <key-file>    # Импортировать приватный ключ из файла