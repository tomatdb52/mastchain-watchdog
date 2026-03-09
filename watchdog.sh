#!/bin/bash

# --- CONFIGURATION ---
# The name of your Mastchain Docker container
CONTAINER_NAME="mastchain-ais"

# Your Uptime Kuma Push URL (Replace with your actual URL)
KUMA_URL="REPLACE_WITH_YOUR_URL"

# Path to the log file
LOG_FILE="$HOME/mc-watchdog.log"
# ---------------------

echo "----- Watchdog run at $(date) -----" >> "$LOG_FILE"

# 1. Check if the Docker container is running
if [ "$(docker inspect -f '{{.State.Running}}' $CONTAINER_NAME 2>/dev/null)" != "true" ]; then
    echo "$(date) - CRITICAL: Container $CONTAINER_NAME is NOT running. Attempting start..." >> "$LOG_FILE"
    docker start $CONTAINER_NAME >> "$LOG_FILE" 2>&1
else
    # 2. Check if SDR hardware is connected (Looking for Realtek chip)
    if ! lsusb | grep -qi "Realtek"; then
        echo "$(date) - FATAL: SDR hardware not found (USB lock-up). Rebooting system!" >> "$LOG_FILE"
        # Optional: Sync disks before rebooting to prevent SD card corruption
        sync
        sudo reboot
    else
        echo "$(date) - Status: Container is running and SDR is connected." >> "$LOG_FILE"
        
        # 3. Send heartbeat signal to Uptime Kuma (if URL is configured)
        if [[ "$KUMA_URL" != "REPLACE_WITH_YOUR_URL" ]]; then
            # Using curl with a 3-time retry logic for network stability
            if curl -fsS --retry 3 "$KUMA_URL" > /dev/null; then
                echo "$(date) - Watchdog: Heartbeat sent successfully." >> "$LOG_FILE"
            else
                echo "$(date) - ERROR: Failed to send heartbeat to Uptime Kuma." >> "$LOG_FILE"
            fi
        fi
    fi
fi
