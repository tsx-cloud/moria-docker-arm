#!/bin/bash

set -e

mkdir -p /root/.steam 2>&1

if [ -f /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.bak ]; then
    echo "[entrypoint] Restoring patched MoriaServer-Win64-Shipping.exe for steam validation"
    rm -f /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe
    mv /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.bak /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe
fi

echo "[entrypoint] Updating Return to Moria  Dedicated Server files..."
/usr/bin/steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "/server" +login anonymous +app_update 3349480 validate +quit

echo "[entrypoint] Patching subsystem in MoriaServer-Win64-Shipping.exe..."
patcher /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe

echo "[entrypoint] Removing /tmp/.X0-lock..."
rm -f /tmp/.X0-lock 2>&1

echo "[entrypoint] Starting Xvfb"
Xvfb :0 -screen 0 1280x1024x24 &

echo "[entrypoint] Launching wine64 Return to Moria..."
exec env DISPLAY=:0.0 wine64 "/server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe" Moria 2>&1
