FROM debian:12 AS builder

ARG THREAD_COUNT="-j4"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git build-essential cmake openssl libssl-dev libmariadb-dev libmariadbd19 libmariadb3 libmysql++-dev libreadline-dev bzip2 pkgconf libboost-all-dev

WORKDIR /
RUN git clone https://github.com/cmangos/mangos-classic.git

RUN mkdir -p /server
WORKDIR /server
RUN cmake /mangos-classic -DCMAKE_INSTALL_PREFIX=/server/install -DBUILD_AHBOT=Yes -DBUILD_EXTRACTORS=Yes
RUN make ${THREAD_COUNT}
RUN make install ${THREAD_COUNT}




FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends openssl libmariadbd19 libmariadb3

COPY --from=builder /server/install /server/install
RUN mkdir -p /server/install/workdir
WORKDIR /server/install/workdir

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/server/install/lib

EXPOSE 3724
EXPOSE 8085

# Use a docker volume when running the image to populate this file:
CMD ["./launch.sh"]
