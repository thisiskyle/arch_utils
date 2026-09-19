#/bin/bash

version="latest"
container_name="calibre"
image="lscr.io/linuxserver/calibre:${version}"


echo "Checking for calibre updates..."

# Get the current image ID used by the container
old_image_id=$(docker inspect --format='{{.Image}}' "$container_name" 2>/dev/null)

# Pull the latest image
docker pull "$image" || {
    echo "Failed to pull calibre image: ${image}"
    exit 1
}

# Get the newly pulled image ID
new_image_id=$(docker image inspect "$image" --format='{{.Id}}')

# If the container exists and is already using the latest image, do nothing
if [ -n "$old_image_id" ] && [ "$old_image_id" = "$new_image_id" ]; then
    echo "calibre is already up to date."
    exit 0
fi

echo "New calibre image detected. Recreating container..."

docker stop ${container_name}
docker rm --force ${container_name}

docker_args=(
    run -d
    --name ${container_name}
    -e PUID=1000
    -e PGID=1001
    --security-opt seccomp=unconfined
    -p 8181:8181
    -p 8081:8081
    --volume /calibre/config:/config
    --volume /nas/public/media/books:/books
    --shm-size="1gb"
    --restart=unless-stopped
    lscr.io/linuxserver/calibre:latest
)

docker "${docker_args[@]}"


if [ $? -eq 0 ]; then
    echo "Calibre successfully updated to: ${image}"
else
    echo "Failed to start Calibre."
    exit 1
fi

