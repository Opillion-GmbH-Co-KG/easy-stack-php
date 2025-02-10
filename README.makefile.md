|--------------------------------|-----------------------------------------------------------------------------|
| Make Commands                  | Description                                                                 |
|--------------------------------|-----------------------------------------------------------------------------|
| `make build`                   | Builds the current stack                                                    |
| `make build-%`                 | Builds and pushes (base/dev/prod) images to Docker Hub with Buildx          |
| `make clean-stack`             | Stops, removes and deletes volumes, images, and networks                    |
| `make console`                 | Runs a bash for php                                                         |
| `make docker-login`            | Logs in to Docker Hub registry                                              |
| `make fix-buildx`              | Fixes a broken Buildx setup                                                 |
| `make fix-line-endings`        | Fixes the line endings of all files                                         |
| `make help`                    | Shows help for make commands                                                |
| `make remove-buildx`           | Removes Buildx runtime container                                            |
| `make restart`                 | Cleans your stack containers, volumes, networks & restarts all services     |
| `make start`                   | Starts all services defined in your docker-compose file                     |
| `make stop`                    | Stops running Docker containers                                             |
| `make validate-docker-compose` | Validates the docker-compose.yml file                                       |
|--------------------------------|-----------------------------------------------------------------------------|
