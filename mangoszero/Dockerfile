FROM debian:12 AS builder

ARG THREAD_COUNT="-j4"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git build-essential cmake openssl libssl-dev libmariadb-dev libmariadbd19 libmariadb3 libmysql++-dev libreadline-dev bzip2 pkgconf

WORKDIR /
RUN git clone --recursive https://github.com/mangoszero/server.git /mangoszero

RUN mkdir -p /server
WORKDIR /server
RUN cmake /mangoszero -DCMAKE_INSTALL_PREFIX=/server/install -DCONF_INSTALL_DIR=/server/install/etc
RUN make ${THREAD_COUNT}
RUN make install ${THREAD_COUNT}
RUN chmod +x /server/install/bin/tools/ExtractResources.sh



FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openssl libmariadbd19 libmariadb3

COPY --from=builder /server/install /server/install
RUN mkdir -p /server/install/workdir
WORKDIR /server/install/workdir

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/server/install/lib

EXPOSE 3724
EXPOSE 8085

# Use a docker volume when running the image to populate this file:
CMD ["./launch.sh"]
