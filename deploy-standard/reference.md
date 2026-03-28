# Deploy Standard Reference

This file defines which values change between projects and how they map into the templates.

## Variable map

- `PROJECT_TITLE`
  - Human-readable project name.
  - Used in the README title and short headings.
  - Example: `Channel BreakOut`

- `PROJECT_SLUG`
  - Kebab-case project/repository name.
  - Used in Windows install directory, Linux install directory, service naming, and update commands.
  - Example: `channel-breakout`

- `REPO_OWNER`
  - GitHub owner or organization.
  - Example: `jesusweb3`

- `REPO_NAME`
  - GitHub repository name.
  - Often the same as `PROJECT_SLUG`.
  - Example: `channel-breakout`

- `REPO_VISIBILITY`
  - Controls how the Linux install command is generated.
  - Allowed values:
    - `public`
    - `private`
  - If this cannot be inferred safely, ask the user before generating README.

- `DEPLOY_BRANCH`
  - Branch used in clone, raw GitHub links, and Linux update commands.
  - Example: `main` or `channel-breakout`

- `DEPLOY_BRANCH_MODE`
  - Decides which Linux update block to generate.
  - Allowed values:
    - `single-main` - the project uses one normal branch, usually `main`
    - `separate-branch` - deploy uses a specific branch and the README should
      show explicit branch switching commands

- `REPO_URL`
  - Clone URL for `git clone`.
  - Default:
    - `https://github.com/REPO_OWNER/REPO_NAME.git`

- `RAW_INSTALL_URL`
  - Direct URL to the Linux installer in the selected branch.
  - Default:
    - `https://raw.githubusercontent.com/REPO_OWNER/REPO_NAME/DEPLOY_BRANCH/deploy/linux/install.sh`

- `GITHUB_TOKEN`
  - Used only in the README Linux curl example for private repositories.
  - Ask for it explicitly when generating README for a private repository.
  - If the user does not provide one, use `__GITHUB_TOKEN__`.

- `SHORT_DESCRIPTION`
  - One or two sentences under the title.

- `HOW_IT_WORKS`
  - Short technical explanation of the core behavior.
  - Keep it concise.

- `RELAY_LOGIC`
  - Optional short project-specific logic section.
  - Omit the entire section if empty.

- `ENV_KEYS`
  - Ordered list of important `.env` variables.
  - Prefer inferring them from `.env.example`.
  - If meanings are obvious, add short explanations.

- `SERVICE_NAME`
  - Docker Compose service name.
  - Default: `PROJECT_SLUG`

- `PYTHON_ENTRYPOINT`
  - Main Python file used in generated start commands and Dockerfile.
  - Default: `main.py`

- `LINUX_INSTALL_DIR`
  - Default:
    - `/root/project/PROJECT_SLUG`

## Standard file mapping

### README

The README should include these sections in order:

1. Title
2. Short description
3. `## Как это работает`
4. Optional `## Логика ретрансляции`
5. `## Установка`
6. `## Обновление`
7. `## Управление`
8. `## Настройки`

### Deploy tree

Use this exact structure:

```text
deploy/
  linux/
    install.sh
  windows/
    install.bat
    install-git-and-python.bat
  docker-compose.yaml
  Dockerfile
```

## Template substitution rules

- README title uses `PROJECT_TITLE`, not the slug.
- Desktop install path on Windows uses `%USERPROFILE%\Desktop\PROJECT_SLUG`.
- Linux install directory uses `LINUX_INSTALL_DIR`.
- `install.bat` and `install.sh` should clone `REPO_URL`.
- Linux README curl example should call `RAW_INSTALL_URL`.
- Linux install command depends on `REPO_VISIBILITY`.
- For `public`, use:
  - `curl -fsSL RAW_INSTALL_URL -o install.sh && chmod +x install.sh && ./install.sh`
- For `private`, use:
  - `curl -fsSL -H "Authorization: token GITHUB_TOKEN" RAW_INSTALL_URL -o install.sh && chmod +x install.sh && ./install.sh`
- If repository visibility cannot be inferred confidently, ask the user before
  generating the README.
- Linux update block depends on `DEPLOY_BRANCH_MODE`.
- For `single-main`, use:
  - `git -C LINUX_INSTALL_DIR pull --ff-only origin DEPLOY_BRANCH`
  - `cd LINUX_INSTALL_DIR/deploy`
  - `docker-compose up -d --build`
- For `separate-branch`, use:
  - `git -C LINUX_INSTALL_DIR fetch origin DEPLOY_BRANCH --prune`
  - `git -C LINUX_INSTALL_DIR checkout DEPLOY_BRANCH`
  - `git -C LINUX_INSTALL_DIR pull --ff-only origin DEPLOY_BRANCH`
  - `cd LINUX_INSTALL_DIR/deploy`
  - `docker-compose up -d --build`
- If the branch strategy cannot be inferred from the repo or the user's wording,
  ask explicitly before generating the README.
- Compose service name should default to `SERVICE_NAME`.
- `docker-compose.yaml` should use `restart: unless-stopped` unless the user explicitly asks for a different policy.
- The Dockerfile should stay on `python:3.13-slim` unless the repo clearly requires another runtime.

## Practical defaults

If the user did not specify something and the repo does not contradict it:

- `REPO_NAME = PROJECT_SLUG`
- `SERVICE_NAME = PROJECT_SLUG`
- `PYTHON_ENTRYPOINT = main.py`
- `LINUX_INSTALL_DIR = /root/project/PROJECT_SLUG`
- Dockerfile copies:
  - `requirements.txt`
  - `src/`
  - `main.py`

## Consistency checklist

Before finishing, verify:

- README file names match the generated deploy files.
- Windows and Linux install paths use the same project slug.
- `REPO_URL`, raw GitHub URL, and branch all point to the same repository.
- `docker-compose.yaml` references `deploy/Dockerfile`.
- The README `Настройки` section matches `.env.example` or the user's supplied variable list.
