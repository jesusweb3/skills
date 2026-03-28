#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-{{REPO_URL}}}"
BRANCH_NAME="${BRANCH_NAME:-{{DEPLOY_BRANCH}}}"
SERVICE_NAME="{{SERVICE_NAME}}"
INSTALL_DIR="{{LINUX_INSTALL_DIR}}"
SERVICE_ENV="$INSTALL_DIR/.env"
COMPOSE_FILE="$INSTALL_DIR/deploy/docker-compose.yaml"

check_dependency() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "[ERROR] $1 is not installed. Install $1 and try again." >&2
        exit 1
    fi
}

check_dependency git
check_dependency docker
check_dependency docker-compose

if [ -d "$INSTALL_DIR" ]; then
    echo "[INFO] $SERVICE_NAME is already installed at $INSTALL_DIR"
    echo "[INFO] Nothing to do."
    exit 0
fi

echo "[INFO] Cloning repository into $INSTALL_DIR..."
git clone --branch "$BRANCH_NAME" "$REPO_URL" "$INSTALL_DIR"

if [ ! -f "$SERVICE_ENV" ] && [ -f "$INSTALL_DIR/.env.example" ]; then
    cp "$INSTALL_DIR/.env.example" "$SERVICE_ENV"
fi

echo
echo "============================================="
echo "  $SERVICE_NAME ready:"
echo "  $INSTALL_DIR"
echo
echo "  Edit configuration:"
echo "  $SERVICE_ENV"
echo
echo "  To start with Docker:"
echo "  cd $INSTALL_DIR/deploy"
echo "  docker-compose up -d --build"
echo
echo "  Compose file:"
echo "  $COMPOSE_FILE"
echo "============================================="
