ARG alpine_docker_url
FROM $alpine_docker_url AS build

# Update the cache
RUN apk update

# Download dependencies
RUN apk add linux-rpi4 raspberrypi-bootloader

RUN rm /boot/vmlinuz-*
RUN rm /boot/initramfs-*
# Good lord I fucked up before
RUN unlink /boot/boot

FROM scratch

COPY --from=build /boot /
