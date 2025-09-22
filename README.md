# keepalived

A Docker image for keepalived, a load balancing and high-availability service for Linux systems.

## Features

- Based on Alpine Linux for minimal size
- Includes keepalived with all necessary dependencies
- Configurable through environment variables and mounted configuration
- Multi-architecture support (amd64, arm64)
- Automatic Docker image builds via GitHub Actions

## Quick Start

### Using Docker Run

```bash
# Run with custom configuration
docker run -d --name keepalived \
  --net=host \
  --cap-add=NET_ADMIN \
  --cap-add=NET_BROADCAST \
  --cap-add=NET_RAW \
  -v $(pwd)/config/keepalived.conf:/etc/keepalived/keepalived.conf:ro \
  -v /lib/modules:/lib/modules:ro \
  ghcr.io/kbase-infra/keepalived:latest
```

### Using Docker Compose

```bash
# Start the service
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the service
docker-compose down
```

## Configuration

### Required Capabilities

keepalived requires the following Linux capabilities:
- `NET_ADMIN` - for network administration
- `NET_BROADCAST` - for broadcast operations  
- `NET_RAW` - for raw socket operations

### Network Mode

The container should run in `host` network mode to properly handle VRRP (Virtual Router Redundancy Protocol) traffic.

### Volume Mounts

- `/etc/keepalived/keepalived.conf` - Main configuration file (required)
- `/lib/modules` - Kernel modules (recommended for IP load balancing)

### Sample Configuration

A sample configuration file is provided in `config/keepalived.conf`. Customize it according to your environment:

```bash
# Edit the configuration
cp config/keepalived.conf config/my-keepalived.conf
# ... edit the file ...

# Run with custom config
docker run -d --name keepalived \
  --net=host \
  --cap-add=NET_ADMIN \
  --cap-add=NET_BROADCAST \
  --cap-add=NET_RAW \
  -v $(pwd)/config/my-keepalived.conf:/etc/keepalived/keepalived.conf:ro \
  ghcr.io/kbase-infra/keepalived:latest
```

## Environment Variables

The container can be customized with these environment variables:

- `KEEPALIVED_INTERFACE` - Network interface to use (default: eth0)
- `KEEPALIVED_PRIORITY` - VRRP priority (default: 100)
- `KEEPALIVED_VIRTUAL_IPS` - Virtual IP addresses

## Building

To build the Docker image locally:

```bash
# Build the image
docker build -t keepalived .

# Run the built image
docker run --rm keepalived keepalived --version
```

## Testing

Test the configuration syntax:

```bash
docker run --rm -v $(pwd)/config/keepalived.conf:/etc/keepalived/keepalived.conf:ro \
  ghcr.io/kbase-infra/keepalived:latest \
  keepalived -t -f /etc/keepalived/keepalived.conf
```

## Security Considerations

- Run with minimal required capabilities
- Use read-only configuration mounts
- Keep the base image updated
- Review and customize the configuration for your environment

## Troubleshooting

### Common Issues

1. **VRRP not working**: Ensure the container runs in host network mode
2. **Permission denied**: Verify the required capabilities are granted
3. **Configuration errors**: Use the test command to validate syntax

### Debugging

Enable debug mode:

```bash
docker run -d --name keepalived \
  --net=host \
  --cap-add=NET_ADMIN \
  --cap-add=NET_BROADCAST \
  --cap-add=NET_RAW \
  -v $(pwd)/config/keepalived.conf:/etc/keepalived/keepalived.conf:ro \
  ghcr.io/kbase-infra/keepalived:latest \
  keepalived -n -l -D -d -f /etc/keepalived/keepalived.conf
```

View logs:
```bash
docker logs -f keepalived
```

## License

This project is open source. Please refer to the repository license for details.