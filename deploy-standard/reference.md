# Deploy Standard Reference

Use this file when you need concrete detection rules before generating deploy files.

## 1. Repository access

For a public repository:

- ask only for the repository URL

For a private repository:

- ask for the repository URL
- ask for a GitHub token
- never print the token back in a final summary
- never save the token into generated files unless the user explicitly asked for that

## 2. Project classification

### Python indicators

Strong signals:

- `requirements.txt`
- `pyproject.toml`
- `poetry.lock`
- `Pipfile`
- `main.py`
- `app.py`
- `manage.py`
- `wsgi.py`
- `asgi.py`

Typical deploy interpretation:

- app service or API: Docker is usually appropriate
- plain CLI utility without a long-running process: Docker may be optional

### Node indicators

Strong signals:

- `package.json`
- `package-lock.json`
- `pnpm-lock.yaml`
- `yarn.lock`
- `server.js`
- `app.js`
- `index.js`
- `dist/server.js`

Typical deploy interpretation:

- API or web server: Docker is usually appropriate
- frontend-only static app: Docker is optional unless the repo already uses container deployment

### Other runtimes

If the repo is clearly Java, Go, PHP, Rust, or another runtime:

- identify the real start command from project files
- generate deploy files for that runtime only if the repo structure makes it clear
- if startup is ambiguous, ask a follow-up question

## 3. Entrypoint detection

Pick the entrypoint from explicit evidence in this order:

1. existing docs or scripts that define how the app starts
2. Dockerfile or compose file already present in the repo
3. framework-specific launch file
4. package manager scripts such as `npm run start`
5. obvious top-level server file

### Python entrypoint hints

Prefer explicit app servers when present:

- FastAPI or Starlette with ASGI app: `uvicorn module:app --host 0.0.0.0 --port <PORT>`
- Flask production deploy: `gunicorn module:app --bind 0.0.0.0:<PORT>`
- Django: `gunicorn project.wsgi:application --bind 0.0.0.0:<PORT>`
- Generic script worker: `python main.py`

Do not switch to `gunicorn` or `uvicorn` unless the dependency or framework is clearly present.

### Node entrypoint hints

Prefer:

- `npm run start` when `package.json` defines a production start script
- `node server.js`, `node app.js`, or `node dist/server.js` when that is explicit

Do not use a dev command such as `npm run dev`, `nodemon`, or `vite` as the production command.

## 4. Dependency detection

### Python

Use one clear dependency source:

- `requirements.txt` if present
- otherwise `pyproject.toml` plus the matching toolchain if the repo is clearly Poetry or another manager

If both exist, prefer the file the project actually uses in its docs or scripts.

### Node

Install from the lockfile that exists:

- `npm ci` for `package-lock.json`
- `pnpm install --frozen-lockfile` for `pnpm-lock.yaml`
- `yarn install --frozen-lockfile` for `yarn.lock`

If no lockfile exists, use `npm install` only if that is the repo's actual package manager.

## 5. Port detection

Only expose a port if the app actually serves traffic.

Look for:

- `.env.example`
- existing README examples
- framework defaults mentioned in code
- `PORT` environment variable usage
- explicit bind addresses in source

If no port can be confirmed:

- do not invent one
- omit `ports:` from compose
- mention in README only what is actually known

## 6. Docker decision rules

Use Docker when:

- the project is a long-running server, API, webhook handler, bot, or worker
- Linux deployment is expected through compose
- the repository is intended to run as a service

Be careful with Docker when:

- the project is a desktop app
- the project is a local-only CLI tool
- the runtime depends on unclear host integrations

If Docker is inappropriate, say so and ask whether the user still wants a containerized deploy.

## 7. Windows script rules

### `install-git-and-python.bat`

This script is a universal bootstrap:

- no repository URL inside
- no token inside
- no project-specific folder names inside unless the script is explicitly generated for a single project result
- it may download official Git and Python installers
- it should stop on failed installs

### `install.bat`

This script is project-specific and may include:

- repository URL
- project folder name
- runtime setup commands

Required behavior:

- fail if the install directory already exists
- clone once
- do first-time environment setup
- create `.env` from `.env.example` when available
- create `start.bat`
- create `update.bat`

For private repos:

- prefer prompting the user for `GITHUB_TOKEN` at runtime or using an environment variable
- do not hardcode a real token into the generated file

## 8. Linux script rules

`install.sh` must:

- check required commands before cloning
- detect `docker compose` versus `docker-compose`
- refuse to overwrite an existing install directory
- clone only once
- prepare `.env`
- not auto-run containers

The script should end with the next commands the user must run manually.

## 9. README writing rules

Keep README factual.

Use this structure:

1. title
2. short description
3. `How it works`
4. `Installation`
5. `Update`
6. `Management`
7. `Settings`

### Description guidance

Base the description on observable repo behavior:

- what the service receives
- what it processes
- what side effects it produces

Avoid vague text such as:

- "modern service"
- "powerful platform"
- "production-grade solution"

### Linux installation block

Must include a full command sequence with:

```bash
sudo -i
apt update
apt install -y git curl wget nano htop unzip ca-certificates software-properties-common docker.io docker-compose
systemctl enable --now docker
curl -fsSL <INSTALL_SH_URL> -o install.sh && chmod +x install.sh && ./install.sh
```

If the repository is private, the command may need an authenticated download flow, but avoid printing a real token.

## 10. Multi-service repositories

If the repository contains multiple deployable apps, do not pick one silently.

Ask:

- which service should be deployed
- whether only one service must go into `docker-compose.yml`

The skill's default is one deploy target and one compose service.

## 11. Final output

At the end, always show:

- file tree
- full contents of generated deploy files
- full contents of generated `README.md`

Do not omit files the user explicitly requested.
