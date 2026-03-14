# l2j-server-docker

L2J Server Docker provides a simple and modular way to run the L2J login and game server stack with Docker Compose.

## Docker installation

Before running the stack, make sure Docker is installed.

- [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
- [Docker on Ubuntu Linux](https://docs.docker.com/engine/install/ubuntu/)
- [Docker installation guide](https://docs.docker.com/engine/install/)

## Quick start

If Docker Compose is already installed on your system.

Clone this repository:

```bash
git clone https://github.com/nonom/l2j-server-docker.git
```

For Linux users running Docker, install and run `make`.

```bash
make up
make logs
make down
```

For Windows users running Docker Desktop, use `compose` bat.

```bat
.\compose up
.\compose logs
.\compose down
```

Use `make` or `compose` to start and stop the full stack.

## Environment

You can override any environment variable in your `.env` file.

The `.env.example` file is included for that purpose. Copy this file if you want to store your own credentials.

## Customization

A data folder is created and initialized based on the server compose files environment configuration, this is an experimental feature. Some examples are provided in the `server/` folder to show how to retrieve and customize your data files.

The `data/` folder is created in your directory, so you can safely store your customizations.

Create a folder inside `server/`, add your `compose.yml` and customize your own data files.

## Database

No make or compose command removes the database volume. Rebuilding images or recreating containers does not delete the database data.

The database will still use the same credentials defined in the `.env` file.

If you want to delete the database data, stop the stack first, and remove it manually.

```bat
docker volume rm l2j-server-docker_l2j-database-data
```

## Roadmap

- Provide more services examples.
- Keep composing as simple as possible.
- Prepare a docs/ folder.
- Improve this README.

## Reference

- [L2J Server](https://www.l2jserver.com/)
- [l2j-server-game-docker](https://bitbucket.org/l2jserver/l2j-server-game-docker)
- [l2j-server-login-docker](https://bitbucket.org/l2jserver/l2j-server-login-docker)
