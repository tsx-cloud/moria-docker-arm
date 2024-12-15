# Dockerized Return to Moria dedicated server in an Ubuntu 22.04 container with Wine

[![GitHub Actions](https://github.com/AndrewSav/moria-docker/actions/workflows/main.yml/badge.svg)](https://github.com/AndrewSav/moria-docker/actions)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/andrewsav/moria?sort=semver)](https://hub.docker.com/r/andrewsav/moria/tags)

This is not an official project and I'm not affiliated with developers or publishers of the the game.

**As of the time of writing this is an early alpha of the Dedicated Server, and this impacts how this docker image is setup. I hope that quite a few things will change as the Alpha progresses.**

## Environment variables


| Variable   | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| steamuser  | During Dedicated Server Alpha the server is tied to the user's steam account. I hope that this requirement will be dropped later. For now head to <https://www.returntomoria.com/news-updates/dedicated-server> for instruction on how to participate in alpha. This should be set up to your steam account name that have the Dedicated Server registered to. See the authenticating section below on how to use this variable. |
| inviteseed | Currently the invite code for the game are printed by the dedicated server to a separate Windows console window which is not available in the docker container running without X. Because of this, to bootstrap the session a Windows machine with the dedicated server will be required to get the invite seed from. I hope that later we will be able to read the invite code from within the container. See the getting the invite code section below on how to use this variable. |

## Ports


| Exposed Container port | Type |
| ------------------------ | ------ |
| 7777                | UDP  |

## Volumes


| Volume             | Container path              | Description                             |
| -------------------- | ----------------------------- | ----------------------------------------- |
| Saves & settings | /mnt/moria/server/Moria/Saved | server logs and saves |
| Steam install path | /mnt/moria/server     | the server files are downloaded into this directory, and settings files are created here on the first start |
| Steam cache | /root/Steam | This is where Steam credentials are cached by steam, so they do not need to be entered on each restart |

## Authentication

*I hope that this won't be required once Dedicated Server leaves alpha.*

First of all you will need to authenticated your docker image with Steam. Edit `docker-compose.yaml` and add the following temporary line at the end (mind the indent):

```yaml
    command: ["/bin/bash","-c","sleep 999999"]
```
Change the `steamuser` variable to indicate your steam user name.

Now start the container:

```bash
docker compose up -d
```

Execute into the container:

```
docker exec -it moria bash
```

Login with Steam (change `your_password` to your steam password):

```bash
steamcmd +login "${steamuser}" "your_password" +quit
```

and follow the prompts for 2FA (if any).

[Example output](https://gist.github.com/AndrewSav/64dc27c70c65d03d4e8b9a1c42814141#file-authentication-txt)

Exit docker container:

```bash
exit
```

Edit `docker-compose.yaml` again and remove the line with `command` you added earlier.

*Note: you will probably need to do the above every time your cached credentials has expired and you (re)start the container*

## Getting the invite code

*I hope this won't be required once Dedicated Server leaves alpha.*

For this you are going to need a windows PC with steam. Run the Dedicated Server there as per [official instructions](https://www.returntomoria.com/news-updates/dedicated-server). Once your server is running you will see a console window with the invite code.

[Example output](https://gist.github.com/AndrewSav/64dc27c70c65d03d4e8b9a1c42814141#file-invite-txt)

Type `exit` and press enter.

Next, find the folder with the dedicated server executable on your PC. You can do it from your steam client, by right-clicking on the dedicated server and selecting "Manage > Browse Local Files" from the menu. Go to "Moria/Saved/Config" subfolder and look for the `InviteSeed.cfg` file. Open the file in editor of your choice and copy the value from it.

Now insert the value in the `docker-compose.yaml` as the value of the `inviteseed` variable.

*Note: you will probably need to do the above every time your session has expired*

## Starting the server

Run

```bash
docker compose up -d --force-recreate
```

You can watch the logs with:

```bash
docker compose logs -f
```

[Example output](https://gist.github.com/AndrewSav/64dc27c70c65d03d4e8b9a1c42814141#file-firstrun-txt)

## Server configuration

Once the server fully started for the first time it will copy the default server settings to `./server/MoriaServerConfig.ini`, `./server/MoriaServerPermissions.txt`,`./server/MoriaServerRules.txt` files.

Edit the files to your liking and restart the containers:

```bash
docker compose up -d --force-recreate
```

Logs are found in `./data/Logs/` directory, and Saves are in ` ./data/SaveGamesDedicated/` directory.

You can now connect to your server from the game (providing that the port forwarding is set up correctly).

## Credits

- https://github.com/Theogalh/ReturnToMoriaServerOnLinuxTutorial
