FROM ubuntu:20.04 AS build
ARG PACKAGES
ARG CROSS
ARG TARGETS
RUN mkdir /build
COPY boot.ipxe .
COPY ipxe .
RUN apt update
RUN apt install -y -o Acquire::Retries=50 ${PACKAGES}
RUN make -j$(nproc) -C src CROSS=${CROSS} ${TARGETS}
COPY ${targets} /build

FROM scratch
COPY --from=build /build /