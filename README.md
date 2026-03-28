# Cursor Agent Skills

Набор моих персональных skills для Cursor. Репозиторий хранит переиспользуемые навыки для типовых задач: стандартный deploy workflow и простой GitHub workflow без лишней рутины.

## Skills

### `deploy-standard`

Создает мой стандартный deploy-набор для приватных проектов.

Что умеет:
- создать только `README`
- создать только папку `deploy`
- создать `deploy + README` вместе

Установка:

```bash
npx skills add https://github.com/jesusweb3/skills.git --skill deploy-standard
```

Примеры запросов:
- `Создай README по моему стандарту`
- `Создай deploy по моему стандарту`
- `Создай deploy и README по моему стандарту`

### `github-standard`

Закрывает мой простой GitHub workflow для локальных проектов.

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

Если нужен конкретный skill только под текущий проект, открываю проект и ставлю его локально:

```bash
npx skills add https://github.com/jesusweb3/skills.git --skill deploy-standard
```

или:

```bash
npx skills add https://github.com/jesusweb3/skills.git --skill github-standard
```

## Структура репозитория

```text
deploy-standard/
github-standard/
```