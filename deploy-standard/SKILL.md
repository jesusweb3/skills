---
name: deploy-standard
description: Creates a production-ready deployment package for a GitHub project. Use when the user asks to generate deploy files, Dockerfile, docker-compose, install scripts, or a deployment README for an existing repository. First ask whether the repository is public or private; for private repos request both the GitHub token and repository URL, and for public repos request the repository URL. After access is confirmed, analyze the project, detect the runtime and entrypoint, then generate `deploy/` scripts and a clean production-ready `README.md` without guessing missing critical details.
---

# Deploy Standard

Use this skill to build a strict, production-ready deploy package for a repository.

## Core rule

Follow the workflow exactly. Do not skip stages. Do not invent critical details that were not confirmed by analysis.

## Step 1: collect repository access

Ask the user:

1. Is the repository public or private?
2. If private:
   - request the GitHub token
   - request the repository URL
3. If public:
   - request the repository URL

Do not continue until these values are provided.

## Step 2: analyze the project

After the repository details are available:

1. Inspect the project structure.
2. Determine:
   - main language: Python, Node, or other
   - runtime entrypoint such as `main.py`, `app.py`, `server.js`, `manage.py`, or an equivalent command from the project files
   - dependency source such as `requirements.txt`, `pyproject.toml`, `package.json`, `Pipfile`, or similar
   - whether Docker is appropriate
   - whether the app exposes a port and which one
3. If the repository is clearly multi-service or the deploy target is ambiguous, stop and ask which service must be deployed.
4. If a critical runtime detail cannot be derived from the repo, ask a precise follow-up question instead of guessing.

Use `reference.md` for detection rules and decision points.

## Step 3: create deploy structure

Generate this structure in the target project:

```text
deploy/
├── docker-compose.yml
├── Dockerfile
├── linux/
│   └── install.sh
└── windows/
    ├── install.bat
    └── install-git-and-python.bat
```

## Step 4: generate Docker files

### Dockerfile

Create a Dockerfile that is:

- adapted to the detected project
- minimal but production-ready
- based on the correct runtime image
- installs dependencies correctly
- uses the correct start command

### docker-compose.yml

Create one service only:

- build from the local Dockerfile
- `restart: always`
- include `env_file: .env` when the project uses environment variables or `.env.example` exists
- map ports only when a port is actually needed and confirmed by analysis

Do not add extra services unless the user explicitly asked for them.

## Step 5: generate Windows scripts

### `install-git-and-python.bat`

Requirements:

- universal bootstrap only
- checks whether Git and Python are installed
- installs missing tools
- contains no project-specific business logic

### `install.bat`

This is a strict install script:

- checks Git and Python
- stops if the target project directory already exists
- clones the repository
- uses a tokenized clone URL only for private repositories
- creates `venv`
- installs dependencies
- creates `.env` from `.env.example` when available
- creates `start.bat`
- creates `update.bat`

`update.bat` must:

1. run `git pull --ff-only`
2. run `pip install --upgrade -r requirements.txt`

Keep install and update strictly separate.

If the analyzed project is not Python-based, adapt the Windows install flow to the actual runtime, but keep the same strict behavior:

- install does first-time setup only
- update does fast-forward pull plus dependency refresh

## Step 6: generate Linux script

### `install.sh`

This is a strict install script:

- checks `git`
- checks `docker`
- checks `docker compose` or `docker-compose`
- stops if the target project directory already exists
- clones the repository
- creates `.env` from `.env.example` when available
- does not run `git pull` on repeated execution
- does not start the container automatically

At the end, print the exact next-step commands:

```bash
cd deploy
docker-compose up -d --build
```

or:

```bash
cd deploy
docker compose up -d --build
```

Pick the command that actually exists on the machine.

## Step 7: generate README

Write `README.md` in this exact structure:

1. project name
2. short description
3. `How it works`
4. `Installation`
5. `Update`
6. `Management`
7. `Settings`

### Windows section

Must include:

- installation steps
- explanation of `install.bat`
- explanation of `install-git-and-python.bat`

### Linux section

Must include a full command block with:

- `sudo -i`
- `apt update`
- package installation
- `systemctl enable docker`
- running `install.sh` via `curl`

### Update section

Must include:

- Windows: `update.bat`
- Linux: `git pull --ff-only` and compose rebuild/start

### Management section

Must include compose commands such as:

- logs
- restart
- down
- up
- up with rebuild

### Settings section

Explain `.env` briefly and factually.

README rules:

- clean
- predictable
- production-ready
- no filler

Use `templates/README.template.md` as a formatting baseline, but adapt all content to the analyzed project.

## Output requirements

When the generation is finished, output:

1. the resulting file tree
2. the full contents of:
   - `deploy/Dockerfile`
   - `deploy/docker-compose.yml`
   - `deploy/windows/install.bat`
   - `deploy/windows/install-git-and-python.bat`
   - `deploy/linux/install.sh`
   - `README.md`

## Hard rules

- do not use project-specific names inside universal bootstrap scripts
- `install` and `update` are different flows; do not merge them
- do not add hidden automation or surprising behavior
- prefer simple predictable scripts over clever scripts
- generate files that are ready to use without manual cleanup
- never expose a token in the final user-facing output or saved files unless the user explicitly requested that exact behavior

## Additional resources

- Read `reference.md` for runtime detection rules and generation heuristics.
- Read `examples.md` for concrete public, private, and ambiguous-repo flows.
- Use files in `templates/` as starting structure, not as final verbatim output.
