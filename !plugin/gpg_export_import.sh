#!/bin/bash

# Проверяем, передан ли аргумент
echo "Проверка аргументов..."
if [ -z "$1" ]; then
  echo "Ошибка: укажите действие 'export' или 'import'"
  echo "Пример: $0 export [key-id] или $0 import <key-file>"
  exit 1
fi

ACTION=$1
echo "Выбрано действие: $ACTION"

# Функция для получения fingerprint по имени или email
get_fingerprint() {
  # Отладочный вывод в stderr, чтобы не попадал в результат
  echo "Запуск функции get_fingerprint..." >&2
  read -p "Введите имя или адрес почты владельца ключа (например, 'Evgen' или 'test@example.com'): " user_input
  echo >&2  # Перенос строки в stderr

  echo "Введено: '$user_input'" >&2
  if [ -z "$user_input" ]; then
    echo "Ошибка: вы не указали имя или email" >&2
    exit 1
  fi

  # Показываем все ключи для справки
  echo -e "Список всех приватных ключей:\n" >&2
  gpg --list-secret-keys --keyid-format LONG >&2

  # Извлекаем fingerprint по имени или email
  echo "Извлекаю fingerprint для '$user_input'..." >&2
  fingerprint=$(gpg --fingerprint "$user_input" | sed -n '/pub/{n;s/ //g;p;q}' | grep -o '[0-9A-F]\{40\}')

  if [ -z "$fingerprint" ]; then
    echo "Ошибка: не найден ключ для '$user_input'" >&2
    echo "Проверьте имя или email и убедитесь, что ключ есть в gpg (--list-secret-keys)" >&2
    exit 1
  fi

  echo "Найден fingerprint для '$user_input': $fingerprint" >&2
  # Возвращаем только fingerprint как результат
  echo "$fingerprint"
}

# Функция для экспорта приватного ключа
export_key() {
  echo "Запуск функции export_key..."
  local key_id=$1
  echo "Переданный key_id: '$key_id'"

  # Если key-id не указан, запрашиваем имя/email и получаем fingerprint
  if [ -z "$key_id" ]; then
    key_id=$(get_fingerprint)
  fi

  # Проверяем, существует ли ключ
  echo "Проверка ключа '$key_id'..."
  if ! gpg --list-secret-keys "$key_id" > /dev/null 2>&1; then
    echo "Ошибка: приватный ключ с ID '$key_id' не найден"
    exit 1
  fi

  # Экспортируем приватный ключ
  echo "Экспортирую приватный ключ с ID '$key_id' в файл private-key.asc..."
  gpg --armor --export-secret-keys "$key_id" > private-key.asc

  if [ $? -eq 0 ]; then
    echo "Успешно экспортирован приватный ключ в 'private-key.asc'"
    echo "Передайте этот файл получателю через безопасный канал!"
  else
    echo "Ошибка при экспорте ключа"
    exit 1
  fi
}

# Функция для импорта приватного ключа
import_key() {
  echo "Запуск функции import_key..."
  local key_file=$1
  echo "Переданный файл: '$key_file'"

  if [ -z "$key_file" ]; then
    echo "Ошибка: укажите файл с приватным ключом"
    exit 1
  fi

  if [ ! -f "$key_file" ]; then
    echo "Ошибка: файл '$key_file' не найден"
    exit 1
  fi

  echo "Импортирую приватный ключ из файла '$key_file'..."
  gpg --import "$key_file"

  if [ $? -eq 0 ]; then
    echo "Успешно импортирован приватный ключ из '$key_file'"
    echo "Проверьте: gpg --list-secret-keys"
  else
    echo "Ошибка при импорте ключа"
    exit 1
  fi
}

# Обработка аргументов
echo "Обработка действия '$ACTION'..."
case "$ACTION" in
  "export")
    export_key "$2"
    ;;
  "import")
    import_key "$2"
    ;;
  *)
    echo "Ошибка: неизвестное действие '$ACTION'"
    exit 1
    ;;
esac

echo "Скрипт завершён"
exit 0
