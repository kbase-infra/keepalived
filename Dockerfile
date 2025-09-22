FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package index and install keepalived
RUN apt-get update && \
    apt-get install -y keepalived && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /etc/keepalived /var/run /var/log

# Copy configuration files
COPY config/keepalived.conf /etc/keepalived/keepalived.conf
COPY scripts/entrypoint.sh /entrypoint.sh

# Make entrypoint executable
RUN chmod +x /entrypoint.sh

# Expose VRRP protocol (multicast)
EXPOSE 112

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["keepalived", "-n", "-l", "-D", "-f", "/etc/keepalived/keepalived.conf"]