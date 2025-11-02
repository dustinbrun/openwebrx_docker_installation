#!/bin/bash
set -euo pipefail

# === Docker Backup Script ===
# Creates a compressed backup of a Docker directory (--backup / -b),
# or deletes backups older than a specified number of days (--clean / -c <days>).

# --- Configuration ---
DEST="/home/pi/docker_backup"
SOURCE="/home/pi/docker"

# --- Functions ---

show_help() {
  cat <<EOF
Usage: $(basename "$0") [COMMAND]

Commands (choose one):
  --backup, -b
        Create a new compressed backup of the directory: ${SOURCE}
        Example: $(basename "$0") --backup

  --clean, -c <days>
        Delete backups in ${DEST} older than <days>. <days> must be a positive integer.
        There is NO default age; this parameter is required when using --clean.
        Example: $(basename "$0") --clean 14

  --help, -h
        Show this help message.

Notes:
- The script must be called with exactly one command (either --backup/-b or --clean/-c <days>).
- If you provide invalid or missing arguments, the script will exit with an error.
EOF
}

is_positive_integer() {
  [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

create_backup() {
  local current_date file_path
  current_date=$(date +"%Y%m%d_%H%M%S")
  file_path="${DEST}/${current_date}_docker.tar.gz"

  echo
  echo "Starting Docker backup at: ${current_date}"
  echo "Source: ${SOURCE}"
  echo "Destination: ${file_path}"
  echo

  mkdir -p "$DEST"
  tar -cpzf "$file_path" "$SOURCE" --checkpoint=.1000
  echo
  echo "Backup created: ${file_path}"
  echo
  echo "Contents of backup directory:"
  ls -lah "$DEST"
}

clean_backups() {
  local days="$1"

  if ! is_positive_integer "$days"; then
    echo "Error: <days> must be a positive integer. Got: '$days'"
    exit 1
  fi

  if [[ ! -d "$DEST" ]]; then
    echo "Error: backup directory does not exist: $DEST"
    exit 1
  fi

  echo
  echo "Deleting backups in '${DEST}' older than ${days} days..."
  echo

  find "$DEST" -type f -name "*.tar.gz" -mtime +"$days" -print -delete

  echo
  echo "Deletion complete."
  echo
  echo "Remaining backups:"
  ls -lah "$DEST" || true
}

# --- Main Argument Handling ---

if [[ $# -eq 0 ]]; then
  echo "Error: no parameters provided."
  echo "Use --help or -h to see available options."
  exit 1
fi

case "$1" in
  --help|-h)
    show_help
    exit 0
    ;;
  --backup|-b)
    if [[ $# -ne 1 ]]; then
      echo "Error: --backup / -b takes no additional arguments."
      echo "Use --help or -h to see usage."
      exit 1
    fi
    create_backup
    ;;
  --clean|-c)
    if [[ $# -ne 2 ]]; then
      echo "Error: --clean / -c requires a single <days> argument (no default)."
      echo "Example: $(basename "$0") --clean 30"
      exit 1
    fi
    clean_backups "$2"
    ;;
  *)
    echo "Error: unknown parameter: $1"
    echo "Use --help or -h to see available options."
    exit 1
    ;;
esac
