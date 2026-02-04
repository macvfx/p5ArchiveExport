#!/bin/bash
# Bash 3.2 compatible
# Copyright Mat X 2026

set -e
IFS=$'\n\t'

# --------------------------------------------------
# CLI OPTIONS
# --------------------------------------------------

FORCE=0

for arg in "$@"; do
    case "$arg" in
        --force|-f)
            FORCE=1
            ;;
        *)
            echo "Usage: $(basename "$0") [--force|-f]"
            echo "  --force, -f   Generate and copy CSVs even if network copies are fresh"
            exit 1
            ;;
    esac
done

# --------------------------------------------------
# HARD-CODED PATHS (launchd-safe)
# --------------------------------------------------

DB_PATH="/usr/local/aw/config/joblog/resources.db"
SQL_QUERIES_DIR="/Library/Scripts/sql/sql_queries"

SEARCH_LABEL="ArchiveJobs_ResourcesDB"
SOURCE_BASE="/Volumes/Backup/AW/ArchiveSQL"

NETWORK_VOLUME="/Volumes/NAS"
DEST_DIR="${NETWORK_VOLUME}/ArchiveCSV"

STATE_BASE="/Users/Shared/ArchiveCSV"
LOG_DIR="${STATE_BASE}/logs"
LOG_FILE="${LOG_DIR}/run.log"

# --------------------------------------------------
# LOGGING
# --------------------------------------------------

mkdir -p "$LOG_DIR"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"
}

log "========== RUN START =========="

# --------------------------------------------------
# VOLUME CHECK
# --------------------------------------------------

if [ ! -d "$NETWORK_VOLUME" ] || ! mount | grep -q "on $NETWORK_VOLUME "; then
    log "ERROR: Network volume not mounted: $NETWORK_VOLUME"
    exit 1
fi

mkdir -p "$DEST_DIR"

# --------------------------------------------------
# FRESHNESS CHECK (skip if network CSVs < 1 day old)
# --------------------------------------------------

MAX_AGE_SECONDS=86400   # 24 hours

if [ "$FORCE" -eq 0 ]; then
    # Find the newest CSV on the network volume
    NEWEST_CSV=""
    NEWEST_MTIME=0

    for csv in "$DEST_DIR"/*.csv; do
        [ -f "$csv" ] || continue
        # stat -f %m works on macOS (BSD stat) – epoch mtime
        MTIME="$(stat -f %m "$csv")"
        if [ "$MTIME" -gt "$NEWEST_MTIME" ]; then
            NEWEST_MTIME="$MTIME"
            NEWEST_CSV="$csv"
        fi
    done

    if [ -n "$NEWEST_CSV" ]; then
        NOW_EPOCH="$(date +%s)"
        AGE=$(( NOW_EPOCH - NEWEST_MTIME ))
        if [ "$AGE" -lt "$MAX_AGE_SECONDS" ]; then
            HOURS_OLD=$(( AGE / 3600 ))
            MINS_OLD=$(( (AGE % 3600) / 60 ))
            log "Network CSVs are fresh (newest: $(basename "$NEWEST_CSV"), ${HOURS_OLD}h ${MINS_OLD}m old). Skipping. Use --force to override."
            log "========== RUN END (skipped) =========="
            exit 0
        fi
        log "Network CSVs are stale (newest: $(basename "$NEWEST_CSV"), $(( AGE / 3600 ))h old). Regenerating."
    else
        log "No existing CSVs on network volume. Generating."
    fi
else
    log "Force mode enabled – skipping freshness check."
fi

# --------------------------------------------------
# GENERATE CSVs
# --------------------------------------------------

NOW="$(date +"%Y-%m-%d_%H%M%S")"
RUN_DIR="${SOURCE_BASE}/${SEARCH_LABEL}-${NOW}"

log "Creating run directory: $RUN_DIR"
mkdir -p "$RUN_DIR"

log "Running SQL queries..."

for sql_file in "$SQL_QUERIES_DIR"/*.sql; do
    [ -e "$sql_file" ] || {
        log "ERROR: No .sql files found in $SQL_QUERIES_DIR"
        exit 1
    }

    base_name="$(basename "$sql_file" .sql)"
    output_csv="${RUN_DIR}/${base_name}_${NOW}.csv"

    log "Generating CSV: $output_csv"

    sqlite3 \
        -cmd ".header on" \
        -cmd ".mode csv" \
        -cmd ".output $output_csv" \
        "$DB_PATH" \
        ".read $sql_file"
done

log "CSV generation complete"

# --------------------------------------------------
# COPY RESULTS TO NETWORK VOLUME
# --------------------------------------------------

log "Copying generated CSVs to network volume"

COPIED_COUNT=0

for csv in "$RUN_DIR"/*.csv; do
    [ -f "$csv" ] || continue

    log "Copying $(basename "$csv")"
    cp -p "$csv" "$DEST_DIR/"
    COPIED_COUNT=$((COPIED_COUNT + 1))
done

log "Copied $COPIED_COUNT CSV files"

log "========== RUN END =========="