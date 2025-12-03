IMAGE_NAME="ais-labs"
LABS_MOUNT_DIR="$(pwd)/Labs"

# Build the Docker image from Dockerfile
docker build -t "$IMAGE_NAME" .

# Run container:
# - Mount Labs directory
# - Set local time inside container using host settings
#     ro for read-only to avoid host's files modification
# - Specify image and start bash shell
docker run -it --rm \
    -v "$LABS_MOUNT_DIR":/Labs \
    -v /etc/localtime:/etc/localtime:ro \
    "$IMAGE_NAME" bash