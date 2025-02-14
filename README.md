# Dockerized Return to Moria dedicated server in an Ubuntu 22.04 container with Wine

[![GitHub Actions](https://github.com/AndrewSav/moria-docker/actions/workflows/main.yml/badge.svg)](https://github.com/AndrewSav/moria-docker/actions)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/andrewsav/moria?sort=semver)](https://hub.docker.com/r/andrewsav/moria/tags)

This is not an official project and I'm not affiliated with developers or publishers of the game. Head to https://www.returntomoria.com/news-updates/dedicated-server for official information / FAQ.

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

## Getting the invite code

**In most cases you do not need this, because you can join to the server directly via address/port as above.**

*Note: currently there is a bug that prevents `./server/Moria/Saved/Config/Status.json` from updating. Once fixed, the below will no longer be necessary, since the invite code will be able to be looked up in that file*

The invite code for the game are printed by the dedicated server to a separate Windows console window which is not available in the docker container running without X. Because of this, to bootstrap the session a Windows machine with the dedicated server will be required to get the invite seed from.

For this you are going to need a windows PC with steam. Run the Dedicated Server there as per [official instructions](https://www.returntomoria.com/news-updates/dedicated-server). Once your server is running you will see a console window with the invite code.

Type `exit` and press enter.

Next, find the folder with the dedicated server executable on your PC. You can do it from your steam client, by right-clicking on the dedicated server and selecting "Manage > Browse Local Files" from the menu. Go to `Moria/Saved/Config` subfolder and look for the `InviteSeed.cfg` file. Open the file in editor of your choice and copy the value from it.

On your dedicated server, stop the server, create file named `./server/Moria/Saved/Config/InviteSeed.cfg` and put the copied value there and a new line. Save and start the server. Now you should be able to use the invite code to join.

## About this docker image

See [APPROACH.md](APPROACH.md)

## Credits

- https://github.com/Theogalh/ReturnToMoriaServerOnLinuxTutorial
