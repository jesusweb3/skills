#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-{{REPO_URL}}}"
INSTALL_DIR="{{INSTALL_DIR}}"
PROJECT_ENV="$INSTALL_DIR/.env"
COMPOSE_DIR="$INSTALL_DIR/deploy"

check_dependency() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "[ERROR] Missing dependency: $1" >&2
        exit 1
    fi
}

check_dependency git
check_dependency docker

if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "[ERROR] Docker Compose is not installed." >&2
    exit 1
fi

if [ -d "$INSTALL_DIR" ]; then
    echo "[ERROR] Install directory already exists:"
    echo "$INSTALL_DIR"
    echo "[INFO] Remove it manually before running install again."
    exit 1
fi

echo "[INFO] Cloning repository into $INSTALL_DIR..."
git clone "$REPO_URL" "$INSTALL_DIR"

if [ -f "$INSTALL_DIR/.env.example" ] && [ ! -f "$PROJECT_ENV" ]; then
    cp "$INSTALL_DIR/.env.example" "$PROJECT_ENV"
    echo "[INFO] Created $PROJECT_ENV from .env.example"
fi

echo
echo "============================================"
echo "Project installed at:"
echo "$INSTALL_DIR"
echo
echo "Next commands:"
echo "cd $COMPOSE_DIR"
echo "$COMPOSE_CMD up -d --build"
echo "============================================"
