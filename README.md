# Dockerized Return to Moria dedicated server in an Ubuntu 22.04 container with Wine

[![GitHub Actions](https://github.com/AndrewSav/moria-docker/actions/workflows/main.yml/badge.svg)](https://github.com/AndrewSav/moria-docker/actions)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/andrewsav/moria?sort=semver)](https://hub.docker.com/r/andrewsav/moria/tags)

This is not an official project and I'm not affiliated with developers or publishers of the game. Head to https://www.returntomoria.com/news-updates/dedicated-server for official information / FAQ. This image is versioned separately and the image version is not in sync with either the game or the dedicated server.

## Ports


| Exposed Container port | Type |
| ------------------------ | ------ |
| 7777                | UDP  |

In order for others to connect to your server you will most likely need to configure port forwarding on your router.

## Volumes


| Volume             | Container path              | Description                             |
| -------------------- | ----------------------------- | ----------------------------------------- |
| Steam install path | /server   | the server files are downloaded into this directory, and settings files are created here on the first start. server logs and saves are located under /server/Moria/Saved |
| Steam cache | /root/Steam | This is where Steam credentials are cached by steam, so they do not need to be entered on each restart |

## Starting the server

In the folder containing `docker-compose.yaml` run

```bash
docker compose up -d --force-recreate
```

You can watch the logs with:

```bash
docker compose logs -f
```

*Note: this readme assumes that you are using supplied `docker-compose.yaml` to start the server. Some parts of this readme may be inaccurate if your settings differ from the provided.*

## Accessing server console

To attach to the console run:

```
docker compose attach moria
```

Then hit `enter` once or twice.

To detach, press:

```
CTRL+p, CTRL+q
```

This may or may not work depending on your terminal, and on whether or not you are using `ssh`. It worked for me in most scenarios.

![ds01](images/ds01.png)

*Technical note: this docker image patches the dedicated server executable [windows subsystem](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#windows-subsystem) from GUI (2) to CUI (3) in order to provide access to the server console*

## Server configuration

Once the server fully started for the first time it will copy the default server settings to `./server/MoriaServerConfig.ini`, `./server/MoriaServerPermissions.txt`,`./server/MoriaServerRules.txt` files.

Edit the files to your liking and restart the containers:

```bash
docker compose up -d --force-recreate
```

Logs are found in `./server/Moria/Saved/Logs/` directory, and Saves are in `./server/Moria/Saved/SaveGamesDedicated/` directory.

You can now connect to your server from the game (providing that the port forwarding is set up correctly).

*Note: read the official notes linked at the top of this README, they will tell you how to set up a password, copy the game world from your single player playthrough and more*

## Connecting to the server

In game, after clicking "Join Other World", select "Advanced Join options". Use "Direct Join" section. Enter the server IP or domain name and the port number in the format prompted on that screen, and enter password if any. Click Join Server. Joining via an invite code is a bit more involved on the server side. Read "Getting the invite code" below if you want to use this option.

## Updating the server

Restart the container. It will check steam for the newer server version on start and update if required. My preferred method of restarting is running `docker compose up -d --force-recreate` but simple `docker restart moria` would suffice. 

## About this docker image

See [APPROACH.md](APPROACH.md)

## Credits

- https://github.com/Theogalh/ReturnToMoriaServerOnLinuxTutorial
