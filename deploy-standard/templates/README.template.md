# {{PROJECT_TITLE}}

{{SHORT_DESCRIPTION}}

## Как это работает

{{HOW_IT_WORKS}}

{{RELAY_LOGIC_SECTION}}
## Установка

### Windows (Python + venv)

Если `Git` и `Python` уже установлены:

1. Скачать `deploy/windows/install.bat`.
2. Запустить `install.bat`.
3. Скрипт клонирует приватный репозиторий в папку `Desktop\{{PROJECT_SLUG}}`.
4. После установки открыть созданную папку.
5. Заполнить `.env` в корне проекта.
6. Запустить `start.bat`.

Если `Git` или `Python` ещё не установлены, сначала запустите `deploy/windows/install-git-and-python.bat`, а затем `install.bat`.

Что делает `install.bat`:

- клонирует ветку `{{DEPLOY_BRANCH}}` из приватного репозитория;
- создаёт виртуальное окружение `venv`;
- устанавливает зависимости из `requirements.txt`;
- копирует `.env.example` в `.env`, если файла ещё нет;
- создаёт `start.bat` для запуска;
- создаёт `update.bat` для обновления проекта.

Повторный запуск `install.bat` ничего не переустанавливает: если папка `{{PROJECT_SLUG}}` уже существует, скрипт завершится без изменений.

### Linux (Docker)

Пример установки на Ubuntu 22.04:

1. Переключиться в `root`:

```bash
sudo -i
```

2. Обновить систему:

```bash
apt update && apt -y upgrade
```

3. Установить зависимости:

```bash
apt install -y git curl wget nano htop unzip ca-certificates software-properties-common docker.io docker-compose
```

4. Запустить Docker:

```bash
systemctl enable --now docker
```

5. Сохранить и запустить `deploy/linux/install.sh`.

```bash
curl -fsSL -H "Authorization: token {{GITHUB_TOKEN}}" {{RAW_INSTALL_URL}} -o install.sh && chmod +x install.sh && ./install.sh
```

6. После установки заполнить `.env`:

```bash
nano {{LINUX_INSTALL_DIR}}/.env
```

Сохранить: `Ctrl+O` -> `Enter`, выйти: `Ctrl+X`.

7. Запустить контейнер:

```bash
cd {{LINUX_INSTALL_DIR}}/deploy
docker-compose up -d --build
```

Повторный запуск `install.sh` ничего не переустанавливает: если папка `{{LINUX_INSTALL_DIR}}` уже существует, скрипт завершится без изменений.

## Обновление

### Windows

Для обновления используйте `update.bat` в корне установленного проекта.

### Linux

```bash
git -C {{LINUX_INSTALL_DIR}} fetch origin {{DEPLOY_BRANCH}} --prune
git -C {{LINUX_INSTALL_DIR}} checkout {{DEPLOY_BRANCH}}
git -C {{LINUX_INSTALL_DIR}} pull --ff-only origin {{DEPLOY_BRANCH}}
cd {{LINUX_INSTALL_DIR}}/deploy
docker-compose up -d --build
```

## Управление

```bash
cd {{LINUX_INSTALL_DIR}}/deploy
docker-compose logs -f       # логи в реальном времени
docker-compose restart       # перезапуск
docker-compose down          # остановка
docker-compose up -d         # запуск без пересборки
docker-compose up -d --build # запуск с пересборкой
```

## Настройки

Скопируйте `.env.example` в `.env` и заполните переменные.

Основные переменные:

{{ENV_KEYS_SECTION}}
