# {{PROJECT_NAME}}

{{SHORT_DESCRIPTION}}

## How it works

{{HOW_IT_WORKS}}

## Installation

### Windows

If `Git` and `Python` are already installed:

1. Download `deploy/windows/install.bat`.
2. Run `install.bat`.
3. Open the created project directory.
4. Fill in `.env` if the project requires configuration.
5. Run `start.bat`.

If `Git` or `Python` is missing, run `deploy/windows/install-git-and-python.bat` first. This script only installs the base tools and contains no project-specific setup.

`install.bat` performs a strict first-time setup:

- checks Git and Python
- refuses to continue if the target directory already exists
- clones the repository
- creates a virtual environment when the project uses Python
- installs dependencies
- creates `.env` from `.env.example` when available
- creates `start.bat`
- creates `update.bat`

### Linux

Example for Ubuntu:

```bash
sudo -i
apt update
apt install -y git curl wget nano htop unzip ca-certificates software-properties-common docker.io docker-compose
systemctl enable --now docker
curl -fsSL {{INSTALL_SCRIPT_URL}} -o install.sh && chmod +x install.sh && ./install.sh
```

After installation:

```bash
cd {{INSTALL_DIR}}/deploy
{{COMPOSE_UP_COMMAND}}
```

## Update

### Windows

Run:

```bat
update.bat
```

### Linux

Run:

```bash
cd {{INSTALL_DIR}}
git pull --ff-only
cd deploy
{{COMPOSE_UP_COMMAND}}
```

## Management

```bash
cd {{INSTALL_DIR}}/deploy
{{COMPOSE_BIN}} logs -f
{{COMPOSE_BIN}} restart
{{COMPOSE_BIN}} down
{{COMPOSE_BIN}} up -d
{{COMPOSE_BIN}} up -d --build
```

## Settings

{{ENV_DESCRIPTION}}
