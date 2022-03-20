ARG alpine_docker_url
FROM $alpine_docker_url AS build

# Update the cache
RUN apk update

# Download dependencies
RUN apk add linux-rpi4 raspberrypi-bootloader

FROM scratch

COPY --from=build /boot /
