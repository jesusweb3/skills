---
name: github-init-standard
description: Initializes a local project as a GitHub repository using the user's fixed first-upload workflow. Use when the user asks to initialize a repository, make the first push to GitHub, connect `origin`, run `git init`, or do an initial upload. Ask for the GitHub repository URL and the branch name if they are missing, then follow the exact command order in this skill.
---

# GitHub Init Standard

Use this skill only for the user's standard first-time GitHub repository initialization flow.

## When to use

Use this skill when the user asks for things like:

- initialize this project on GitHub
- make the first upload
- connect this folder to a GitHub repo
- run the initial push
- set `origin` and push `main`

Do not use this skill for:

- regular day-to-day commits
- updating an already configured repository unless the user explicitly wants to reinitialize or fix the first setup
- pull requests, rebases, merges, or release flows

## Required inputs

Before running commands, make sure you know:

- `REPO_URL`: the GitHub repository URL for `origin`
- `BRANCH_NAME`: the branch to rename to and push, for example `main`

If either value is missing, ask for it first.

## Fixed workflow

Follow this order exactly:

1. `git init`
2. `git add .`
3. `git commit -m "initial upload"`
4. `git remote add origin <REPO_URL>`
5. `git branch -m <BRANCH_NAME>`
6. `git push -u origin <BRANCH_NAME>`

## Execution rules

- Keep the first commit message exactly: `initial upload`
- Use the same `BRANCH_NAME` in both `git branch -m` and `git push -u origin`
- Show the user the exact commands before running them if they asked for guidance instead of execution
- If `origin` already exists, stop and tell the user instead of blindly replacing it
- If the directory is already a git repository, stop and confirm whether the user wants to continue
- If there is nothing to commit, explain that before trying to push

## Safety checks

Before running the workflow:

1. Check whether the folder is already a git repository.
2. Check whether `origin` already exists.
3. Confirm `REPO_URL`.
4. Confirm `BRANCH_NAME`.

If everything is clean, run the workflow.

## Output style

When helping the user:

- keep it short
- show the final command sequence clearly
- if a step is blocked, explain exactly what blocked it

## Additional resources

- Read `examples.md` when you want concrete trigger examples or a ready-made command sequence.

## Example command sequence

```bash
git init
git add .
git commit -m "initial upload"
git remote add origin https://github.com/USER/REPO.git
git branch -m main
git push -u origin main
```
