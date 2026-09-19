#!/bin/bash

version="10.11.2"
container_name="jellyfin"
image="jellyfin/jellyfin:${version}"

echo "Checking for Jellyfin updates..."


# Get the current image ID used by the container
old_image_id=$(docker inspect --format='{{.Image}}' "$container_name" 2>/dev/null)


# Pull the latest image
docker pull "$image" || {
    echo "Failed to pull Jellyfin image: ${image}"
    exit 1
}


# Get the newly pulled image ID
new_image_id=$(docker image inspect "$image" --format='{{.Id}}')


# If the container exists and is already using the latest image, do nothing
if [ -n "$old_image_id" ] && [ "$old_image_id" = "$new_image_id" ]; then
    echo "Jellyfin is already up to date."
    exit 0
fi


echo "New Jellyfin image detected. Recreating container..."


docker stop ${container_name}
docker rm --force ${container_name}


docker_args=(
    run -d
	--name "${container_name}"
	--user 1000:984
	-p 8096:8096
	--volume /jellyfin/config:/config
	--volume /jellyfin/cache:/cache
	--volume /nas/public/media:/media
	--restart unless-stopped
	"${image}"
)


docker "${docker_args[@]}"


if [ $? -eq 0 ]; then
    echo "Jellyfin successfully updated to: ${image}"
else
    echo "Failed to start Jellyfin."
    exit 1
fi
