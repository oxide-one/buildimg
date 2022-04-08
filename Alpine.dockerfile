ARG alpine_docker_url
FROM $alpine_docker_url AS build

# Optional arguments
ARG alpine_flavor=lts
ARG alpine_features="base squashfs network dhcp https"
# Required arguments
ARG alpine_version
ARG alpine_arch

# Make Directory
RUN mkdir -p /build/$(cat /etc/apk/arch)

# Update the cache
RUN apk update

# Download dependencies
RUN apk add alpine-sdk build-base apk-tools alpine-conf busybox fakeroot xz-dev mkinitfs

RUN echo -e "https://dl-cdn.alpinelinux.org/alpine/v${alpine_version}/main\nhttps://dl-cdn.alpinelinux.org/alpine/v${alpine_version}/community" > /tmp/repositories

RUN cat /tmp/repositories
COPY initramfs-init /usr/share/mkinitfs/initramfs-init
COPY build.sh .
COPY features/* /etc/mkinitfs/features.d/
RUN cat /etc/mkinitfs/features.d/splash.files
# Build the kernel
RUN sh build.sh "${alpine_flavor}" "${alpine_features}"
	
RUN ls /build
FROM scratch

COPY --from=build /build /
