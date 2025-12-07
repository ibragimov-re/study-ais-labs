FROM debian:12

# Automatic confirmation for apt commands
ENV DEBIAN_FRONTEND=noninteractive

# Install needed for labs packets and clean up apt cache
RUN apt-get update && \
    apt-get install -y cron curl nginx openssh-server iptables netcat-openbsd && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

# SSH server setup
RUN mkdir -p /run/sshd

# Start SSH server and bash for interactive use
CMD ["/bin/bash", "-c", "/usr/sbin/sshd && exec bash"]

# Expose port 80 for nginx
EXPOSE 80