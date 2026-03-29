# Examples

## Example 1: first setup

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

## Example 2: ask for missing setup values

User:

```text
Помоги сделать первый пуш на GitHub. Ссылку на репозиторий сейчас пришлю.
```

Expected behavior:

1. Ask for:
   - GitHub repository URL
   - branch name
2. After receiving them, follow the fixed workflow from `SKILL.md`.
3. Try a normal `git push -u origin <branch>` first using the machine's existing
   local git authentication.
4. Do not jump straight to token-based push.

## Example 3: save changes

User:

```text
Зафиксируй изменения в репозитории и сразу запушь.
```

Expected behavior:

1. Run `git add .`
2. Inspect the diff
3. Write a commit message from the actual changes
4. Commit
5. Push to the current branch, usually `main`

## Example 4: untrack file

User:

```text
Убери README.md из отслеживания Git, зафиксируй это и запушь.
```

Expected behavior:

1. Run `git rm --cached README.md`
2. Write a commit message that clearly describes removing the file from tracking
3. Push to the current branch

## Example 5: first push auth failure

User:

```text
Сделай первый пуш этого проекта в GitHub.
```

Expected behavior:

1. Run the standard first setup flow.
2. Try a normal `git push -u origin main` first.
3. If push fails with an auth error, explain that the normal local GitHub
   authentication did not work.
4. Do not immediately rewrite `origin` or propose embedding a token unless the
   user explicitly wants a fallback method.
