# Examples

## Example 1: public repository

User:

```text
Сделай production-ready deploy для моего проекта.
```

Expected behavior:

1. Ask whether the repository is public or private.
2. If public, ask only for the repository URL.
3. Do not continue until the URL is received.
4. Analyze the repository and generate:
   - `deploy/Dockerfile`
   - `deploy/docker-compose.yml`
   - `deploy/linux/install.sh`
   - `deploy/windows/install.bat`
   - `deploy/windows/install-git-and-python.bat`
   - `README.md`

## Example 2: private repository

User:

```text
Подготовь deploy для приватного GitHub-репозитория.
```

Expected behavior:

1. Ask whether the repository is public or private.
2. For a private repo, request:
   - GitHub token
   - repository URL
3. Do not analyze anything until both values are provided.
4. Never print the token in the final output.

## Example 3: Python API

Repository signals:

- `requirements.txt`
- `main.py`
- FastAPI app found in source
- `.env.example`

Expected behavior:

1. Detect Python.
2. Detect the correct ASGI entrypoint.
3. Generate a production Dockerfile with Python base image and dependency install.
4. Generate compose with `restart: always` and `env_file: .env`.
5. Generate Windows install flow with `venv`, `start.bat`, and `update.bat`.
6. Generate Linux install flow that clones only once and does not auto-start containers.

## Example 4: multi-service repository

User:

```text
Сделай deploy для этого репозитория.
```

Repository signals:

- `backend/`
- `frontend/`
- both contain separate runtime manifests

Expected behavior:

1. Analyze the structure.
2. Stop and ask which service must be deployed.
3. Do not silently choose one service.

## Example 5: missing critical runtime detail

Repository signals:

- Python project detected
- dependency file exists
- no clear server entrypoint

Expected behavior:

1. Report what was detected.
2. Ask one precise follow-up question about the missing start command.
3. Continue only after that detail is resolved.
