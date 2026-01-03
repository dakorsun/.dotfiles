
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

log() {
  printf '\n\033[1;34m==> %s\033[0m\n' "$1"
}


if [[ -x "$ROOT_DIR/runs/drivers/main.sh" ]]; then
  log "Running runs/drivers/main.sh"
  "$ROOT_DIR/runs/drivers/main.sh"
else
  echo "runs/drivers/main.sh not found or not executable"
  exit 1
fi


log "Running numbered scripts"

mapfile -t SCRIPTS < <(
  find "$ROOT_DIR/runs" -maxdepth 1 -type f \
    -regextype posix-extended \
    -regex '.*/[1-9][0-9]-.*\.sh' \
    | sort
)

for script in "${SCRIPTS[@]}"; do
  log "Running $(basename "$script")"
  bash "$script"
done
