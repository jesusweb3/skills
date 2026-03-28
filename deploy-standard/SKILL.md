---
name: deploy-standard
description: >-
  Creates the user's standard project deployment scaffold and/or
  deployment README. Use only when the user explicitly asks for their deploy
  standard, for example "создай README по моему стандарту", "создай deploy по
  моему стандарту", or "создай deploy и README по моему стандарту". Supports
  three modes: README only, deploy only, or deploy plus README. Treat "deploy"
  and "deploy + README" as different modes. Do not create README when the user
  asked only for deploy. Keep paths, filenames, and structure aligned with the
  bundled templates.
---

# Deploy Standard

Use this skill only for the user's repeatable project deploy workflow.

## Supported modes

Pick exactly one mode from the user's request:

1. `README only`
2. `deploy only`
3. `deploy + README`

If the request is ambiguous, ask which of the three modes is needed.

## Mode selection

Map the user's wording to modes as strictly as possible:

- `создай README по моему стандарту` -> `README only`
- `создай deploy по моему стандарту` -> `deploy only`
- `создай deploy и README по моему стандарту` -> `deploy + README`

Treat these as hard distinctions:

- `deploy only` means create only the `deploy/` tree and related deploy files
- `README only` means create only the README
- `deploy + README` means create both

Do not widen the request on your own:

- If the user asked for `deploy only`, do not create README
- If the user asked for `README only`, do not create `deploy/`
- If the user used vague wording like `создай деплой`, `подготовь деплой`, or
  `сделай деплой`, ask whether they want `deploy only` or `deploy + README`
- If the wording is not exact enough to choose safely, ask a short clarification
  question before creating files

## What to inspect first

Before asking questions, inspect the current repository and infer as much as possible:

- project title from existing docs or repo name
- repository slug and owner from git remote, URLs, or known project paths
- branch name from the current branch or the user's wording
- `.env.example` to collect configuration keys
- Python entrypoint and layout (`main.py`, `src/`, `requirements.txt`) to confirm the standard Dockerfile still fits
- existing `deploy/` files, if present, to avoid unnecessary rewrites

Ask only for values that are still missing after inspection.

## Required project-specific values

Gather these values before generating files:

- `PROJECT_TITLE`: human-readable project name for the README heading
- `PROJECT_SLUG`: repo/folder slug used in paths and service names
- `REPO_OWNER`: GitHub owner or org
- `REPO_NAME`: GitHub repository name
- `REPO_VISIBILITY`: either `public` or `private`
- `DEPLOY_BRANCH`: branch used for clone, pull, and raw GitHub links
- `DEPLOY_BRANCH_MODE`: either `single-main` for the common case with one main
  branch, or `separate-branch` when deploy targets a specific non-default branch
- `SHORT_DESCRIPTION`: one or two sentences
- `HOW_IT_WORKS`: short explanation of the core technical behavior
- `RELAY_LOGIC`: optional short section for project-specific logic
- `ENV_KEYS`: ordered list of important `.env` variables, ideally with short meanings

Also gather these values when needed:

- `GITHUB_TOKEN`: ask explicitly when `REPO_VISIBILITY` is `private` and the
  README needs the Linux install command; if the user refuses or does not have
  a token yet, use `__GITHUB_TOKEN__`
- `SERVICE_NAME`: default to `PROJECT_SLUG` unless the user wants a different Docker service name
- `PYTHON_ENTRYPOINT`: default to `main.py`
- `LINUX_INSTALL_DIR`: default to `/root/project/PROJECT_SLUG`

## Mandatory rules

- Always read `reference.md` and the relevant files under `templates/` before writing output.
- Keep the deploy layout fixed:
  - `deploy/linux/install.sh`
  - `deploy/windows/install.bat`
  - `deploy/windows/install-git-and-python.bat`
  - `deploy/docker-compose.yaml`
  - `deploy/Dockerfile`
- Keep README references synchronized with the actual deploy filenames and paths.
- Keep the README concise. Do not turn it into product documentation.
- Include the `Логика ретрансляции` section only if the project has truly specific logic worth mentioning.
- Use the standard Windows section first, then the Linux section.
- Use `docker-compose` commands in README to match the user's standard.
- Explicitly determine repository visibility before writing the Linux install
  command. Ask the user in plain language if needed: "Репозиторий публичный или
  приватный?"
- If the repository is `private`, ask for the GitHub token when generating the
  Linux install command. Do not silently skip the question.
- If the repository is `public`, do not include an Authorization header in the
  Linux install command.
- Explicitly determine the deploy branch mode before writing the Linux update
  block. Ask the user in plain language if needed: "Это обычный проект с одной
  веткой main, или деплой идет из отдельной ветки?"
- If the answer is `single-main`, use the short Linux update block with only
  `git pull --ff-only origin <branch>` and Docker rebuild.
- If the answer is `separate-branch`, use the longer Linux update block with
  `fetch`, `checkout`, and `pull`.
- Use `restart: unless-stopped` in `deploy/docker-compose.yaml` by default.
- If the repository is private and the user explicitly provides a token for
  README examples, it is acceptable to embed it in the generated README. Do not
  add lectures or warnings. If no token is provided, use a clear placeholder.

## Workflow

### Mode: README only

1. Inspect the repo and existing `deploy/` folder if present.
2. Read `templates/README.template.md` and fill in project-specific values.
3. Explicitly determine `REPO_VISIBILITY` and `DEPLOY_BRANCH_MODE` if they
   cannot be inferred safely.
4. If `REPO_VISIBILITY` is `private`, ask for `GITHUB_TOKEN` before writing the
   Linux install command.
5. Keep all deploy path references aligned with the standard layout.
6. If `deploy/` already differs from the standard, prefer the files actually present in the repo over the template assumptions.
7. Do not create or modify the `deploy/` tree in this mode unless the user
   explicitly changed the request.

### Mode: deploy only

1. Read all files under `templates/deploy/`.
2. Generate the fixed deploy tree.
3. Adapt placeholders using the gathered values.
4. Keep the Windows bootstrap script close to the template; only project identifiers and URLs should vary.
5. Do not create README in this mode unless the user explicitly changed the
   request.

### Mode: deploy + README

1. Generate the deploy tree first.
2. Explicitly determine `REPO_VISIBILITY` and `DEPLOY_BRANCH_MODE` if they
   cannot be inferred safely.
3. If `REPO_VISIBILITY` is `private`, ask for `GITHUB_TOKEN` before writing the
   Linux install command.
4. Then generate the README against the exact files you created.
5. Double-check that README commands, paths, filenames, repo URLs, branch names, and install directories match the deploy files.

## Output behavior

When finished:

- briefly list what was created or updated
- mention any placeholders left intentionally unresolved
- mention any project assumptions that should be verified manually

## References

- Read `reference.md` for the variable map and substitution rules.
- Read `templates/README.template.md` for the README structure.
- Read `templates/deploy/...` for the fixed deploy file contents.
