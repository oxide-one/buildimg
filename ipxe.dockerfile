FROM ubuntu:20.04 AS build
ARG PACKAGES
ARG CROSS
ARG TARGETS
RUN mkdir /build

COPY boot.ipxe .
COPY ipxe /ipxe

WORKDIR /ipxe

RUN apt update
RUN apt install -y -o Acquire::Retries=50 mtools syslinux isolinux gcc-aarch64-linux-gnu make

RUN ls ipxe/src/*/*.efi

RUN make -j$(nproc) -C ipxe/src  CROSS=aarch64-linux-gnu- bin-arm64-efi/ipxe.efi 
RUN make -j$(nproc) -C ipxe/src  bin-x86_64-efi/ipxe.efi 

COPY ipxe/src/bin-x86_64-efi/ipxe.efi /build/ipxe-amd64.efi
COPY ipxe/src/bin/ipxe.efi /build/ipxe-aarch64.efi

FROM scratch
COPY --from=build /build /
