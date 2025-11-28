IMAGE_NAME="ais-labs"
LABS_MOUNT_DIR="$(pwd)/Labs"

docker build -t "$IMAGE_NAME" .

docker run -it --rm -v "$LABS_MOUNT_DIR":/Labs "$IMAGE_NAME" bash