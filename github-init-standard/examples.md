# Examples

## Example 1

User:

```text
Инициализируй этот проект в GitHub. Репозиторий: https://github.com/example/my-app.git, ветка main.
```

Expected behavior:

1. Confirm the repo is not already initialized and that `origin` does not exist.
2. Run:

```bash
git init
git add .
git commit -m "initial upload"
git remote add origin https://github.com/example/my-app.git
git branch -m main
git push -u origin main
```

## Example 2

User:

```text
Помоги сделать первый пуш на GitHub. Ссылку на репозиторий сейчас пришлю.
```

Expected behavior:

1. Ask for:
   - GitHub repository URL
   - branch name
2. After receiving them, follow the fixed workflow from `SKILL.md`.
