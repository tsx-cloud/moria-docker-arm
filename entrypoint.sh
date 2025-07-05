#!/bin/bash

set -e

wine --version

if [ -f /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.bak ]; then
    echo "[entrypoint] Restoring patched MoriaServer-Win64-Shipping.exe for steam validation"
    rm -f /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe
    mv /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.bak /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe
fi

echo "[entrypoint] Updating Return to Moria  Dedicated Server files..."
steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "/server" +login anonymous +app_update 3349480 validate +quit

echo "[entrypoint] Patching subsystem in MoriaServer-Win64-Shipping.exe..."
patcher /server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe

echo "[entrypoint] Launching wine64 Return to Moria..."
exec wine "/server/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe" Moria 2>&1
