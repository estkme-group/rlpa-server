# Remote LPA Server

Technical details, see [Protocol Design](docs/protocol-design.md)

## Usage on Docker

You can also run the server using [Docker](https://docs.docker.com/engine/install/).
You can use the following command to run the server:

```bash
docker run --detach --name rlpa-server --publish 1888:1888 estkme/rlpa-server:latest
# or use the GitHub Container Registry
docker run --detach --name rlpa-server --publish 1888:1888 ghcr.io/estkme-group/rlpa-server:latest
```

## Community implementation

- <https://github.com/damonto/estkme-cloud>

## LICENSE

[AGPLv3 LICENSE](LICENSE)
