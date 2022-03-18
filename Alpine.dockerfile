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
RUN apk add alpine-sdk build-base apk-tools alpine-conf busybox fakeroot xz-dev

RUN echo -e "https://dl-cdn.alpinelinux.org/alpine/v${alpine_version}/main\nhttps://dl-cdn.alpinelinux.org/alpine/v${alpine_version}/community" > /tmp/repositories

RUN cat /tmp/repositories
# Build the kernel
RUN update-kernel \
          --media \
          --flavor "$alpine_flavor" \
          --arch "$(cat /etc/apk/arch)" \
          -F "${alpine_features}" \
          --repositories-file /tmp/repositories \
          /build/$(cat /etc/apk/arch)

FROM scratch

COPY --from=build /build /