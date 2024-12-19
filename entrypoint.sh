#!/bin/bash

s=/mnt/moria/server
p=/mnt/moria/server/Moria/Saved

mkdir -p /root/.steam 2>&1

echo "[entrypoint] Updating Return to Moria  Dedicated Server files..."
/usr/bin/steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$s" +login "${steamuser}" +app_update 3349480 validate +quit

echo "[entrypoint] Removing /tmp/.X0-lock..."
rm -f /tmp/.X0-lock 2>&1

echo "[entrypoint] Re(setting) invite seed..."
echo -n "${inviteseed}" > ${p}/Config/InviteSeed.cfg

echo "[entrypoint] Starting Xvfb"
Xvfb :0 -screen 0 1280x1024x24 &

echo "[entrypoint] Launching wine64 Return to Moria..."
exec env DISPLAY=:0.0 wine64 "${s}/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe" Moria 2>&1
