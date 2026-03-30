# Cursor Agent Skills

Набор переиспользуемых skills для Cursor. Репозиторий хранит два рабочих сценария: production-ready deploy generation и простой GitHub workflow для локальных проектов.

## Skills

### `deploy-standard`

Создает production-ready deploy-набор для GitHub-репозитория после обязательного анализа проекта.

Что умеет:
- сначала спрашивает, репозиторий публичный или приватный
- для приватного репозитория запрашивает `GitHub token` и ссылку
- анализирует структуру проекта, язык, entrypoint и зависимости
- генерирует `deploy/` с `Dockerfile`, `docker-compose.yml`, `linux/install.sh`, `windows/install.bat`, `windows/install-git-and-python.bat`
- генерирует чистый `README.md` по фиксированной production-ready структуре
- в конце показывает структуру файлов и полное содержимое сгенерированных deploy-файлов

Установка:

```bash
npx skills add https://github.com/jesusweb3/skills.git --skill deploy-standard
```

Примеры запросов:
- `Создай production-ready deploy skill для этого проекта`
- `Сгенерируй deploy и README для моего GitHub-репозитория`
- `Подготовь Dockerfile, compose и install-скрипты после анализа репозитория`

### `github-standard`

Закрывает простой GitHub workflow для локальных проектов.

Что умеет:
- сделать первый push нового проекта
- сохранить текущие изменения через `commit + push`
- убрать файл из отслеживания через `git rm --cached`, затем закоммитить и запушить

Установка:

```bash
npx skills add https://github.com/jesusweb3/skills.git --skill github-standard
```

Примеры запросов:
- `Сделай первый пуш этого проекта в GitHub`
- `Зафиксируй изменения в репозитории и сразу запушь`
- `Убери README.md из отслеживания Git, зафиксируй это и запушь`

## Быстрый старт

Установка `deploy-standard`:

```bash
npx skills add https://github.com/jesusweb3/skills.git --skill deploy-standard
```

Установка `github-standard`:

```bash
npx skills add https://github.com/jesusweb3/skills.git --skill github-standard
```

## Структура репозитория

```text
deploy-standard/
  SKILL.md
  examples.md
  reference.md
  templates/
github-standard/
```