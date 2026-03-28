---
name: github-standard
description: Handles the user's simple GitHub workflow for local projects. Use when the user asks to initialize a repository, make the first push, save and push changes during development, write a commit message from the current diff, or stop tracking a file with `git rm --cached` and then commit and push. Prefer the current branch when one already exists; for first setup, ask for the GitHub repository URL and branch name if missing, then follow the fixed order in this skill.
---

# GitHub Standard

Use this skill only for the user's simple GitHub workflow.

## When to use

Use this skill when the user asks for things like:

- initialize this project on GitHub
- make the first upload
- connect this folder to a GitHub repo
- run the initial push
- save and push current changes
- write a commit message from the current diff
- stop tracking a file in git
- remove a file from tracking with `git rm --cached`

Do not use this skill for:

- pull requests, rebases, merges, or release flows
- branch-heavy workflows or feature-branch strategies
- destructive history rewriting unless the user explicitly asks for it

## Supported modes

Pick the matching mode from the user's request:

1. `first setup`
2. `save changes`
3. `untrack file`

If the request is ambiguous, ask which mode is needed.

## Mode: first setup

Before running commands, make sure you know:

- `REPO_URL`: the GitHub repository URL for `origin`
- `BRANCH_NAME`: the branch to rename to and push, for example `main`

If either value is missing, ask for it first.

Follow this order exactly:

1. `git init`
2. `git add .`
3. `git commit -m "initial upload"`
4. `git remote add origin <REPO_URL>`
5. `git branch -m <BRANCH_NAME>`
6. `git push -u origin <BRANCH_NAME>`

## Mode: save changes

Use this for the user's regular development flow.

Follow this order:

1. `git add .`
2. inspect the current diff
3. write a concise commit message based on what changed
4. `git commit -m "<GENERATED_MESSAGE>"`
5. `git push origin <CURRENT_BRANCH>`

Rules:

- Prefer the current checked-out branch.
- If the current branch cannot be detected, ask for the branch name.
- The user usually pushes immediately after commit, so do not stop after commit unless the user explicitly asks you to.
- The commit message should describe the change compared with the previous version, not just repeat filenames.

## Mode: untrack file

Use this when the user wants to stop tracking a file that is already in Git.

Follow this order:

1. confirm the file path
2. `git rm --cached <FILE>`
3. inspect the diff
4. write a commit message that clearly says the file was removed from tracking
5. `git commit -m "<GENERATED_MESSAGE>"`
6. `git push origin <CURRENT_BRANCH>`

Rules:

- This mode removes the file from Git tracking only; it does not delete the local file.
- If the file should also be ignored in the future, remind yourself to check `.gitignore` and mention it to the user if needed.

## Execution rules

- Keep the first commit message exactly: `initial upload`
- Use the same `BRANCH_NAME` in both `git branch -m` and `git push -u origin` during first setup
- Show the user the exact commands before running them if they asked for guidance instead of execution
- If there is nothing to commit, explain that before trying to push
- If `origin` already exists during first setup, stop and tell the user instead of blindly replacing it
- If the directory is already a git repository during first setup, stop and confirm whether the user wants to continue
- When generating commit messages, prefer short messages that describe the actual change, for example `add deploy-standard skill` or `update github workflow skill examples`

## Safety checks for first setup

Before running the workflow:

1. Check whether the folder is already a git repository.
2. Check whether `origin` already exists.
3. Confirm `REPO_URL`.
4. Confirm `BRANCH_NAME`.

If everything is clean, run the workflow.

## Safety checks for save changes and untrack file

Before running the workflow:

1. Check the current branch.
2. Check whether there are staged or unstaged changes.
3. Inspect the diff before writing the commit message.
4. If the branch is `main`, that is fine; the user usually works directly on `main`.

## Output style

When helping the user:

- keep it short
- show the final command sequence clearly
- if a step is blocked, explain exactly what blocked it

## Additional resources

- Read `examples.md` when you want concrete trigger examples or a ready-made command sequence.

## Example command sequences

### First setup
```bash
git init
git add .
git commit -m "initial upload"
git remote add origin https://github.com/USER/REPO.git
git branch -m main
git push -u origin main
```

### Save changes
```bash
git add .
git commit -m "update deploy-standard templates"
git push origin main
```

### Untrack file
```bash
git rm --cached README.md
git commit -m "stop tracking README.md"
git push origin main
```
