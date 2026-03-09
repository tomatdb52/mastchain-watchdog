# Mastchain Station Watchdog

An automated stability watchdog designed for **Mastchain stations** running via **Docker**. This script is specifically optimized for **Raspberry Pi** and other Linux-based systems to ensure 24/7 uptime.

## Why use this Watchdog?
Hardware nodes like Raspberry Pis can sometimes experience USB lock-ups or container crashes due to heat or power fluctuations. This script acts as a self-healing layer, detecting these issues and fixing them within minutes without manual intervention.

## Key Features
* **Docker Container Monitoring:** Periodically verifies that the `mastchain-ais` container (C-Man version) is active and running.
* **SDR Hardware Validation:** Checks if the USB SDR-stick (Realtek chip) is responsive.
* **Automated Recovery:**
    * If the Docker container stops, the watchdog restarts it immediately.
    * If the SDR hardware freezes, the script triggers a safe system reboot to reset the USB bus.
* **Remote Alerts:** Sends a heartbeat signal to an Uptime Kuma dashboard. If the station goes dark, you get an instant notification via Discord.

## Quick Installation

1. **Download the script:**
```bash
curl -O https://raw.githubusercontent.com/tomatdb52/mastchain-watchdog/main/watchdog.sh
```

2. **Make it executable**
```bash
chmod +x watchdog.sh
```

3. **Configure your Heartbeat (Optional):**  
Edit the file and add your Uptime Kuma Push URL in the KUMA_URL field.

4. **Schedule it:**  
Add the script to your crontab to run every 5 minutes:

```bash
(crontab -l ; echo "*/5 * * * * /bin/bash $HOME/watchdog.sh") | crontab -
```

## Proven Reliability

This system has been verified to catch and resolve container failures automatically, restoring station services within 5 minutes of a downtime event.
