FROM debian:12

# Automatic confirmation for apt commands
ENV DEBIAN_FRONTEND=noninteractive

# Install cron and clean up apt cache
RUN apt-get update && \
    apt-get install -y cron && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

CMD ["/bin/bash"]