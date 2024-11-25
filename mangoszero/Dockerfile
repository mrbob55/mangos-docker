FROM debian:12 AS builder

ARG THREAD_COUNT="-j4"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git build-essential cmake openssl libssl-dev libmariadb-dev libmariadbd19 libmariadb3 libmysql++-dev libreadline-dev

WORKDIR /
RUN git clone https://github.com/mangoszero/server.git --recursive
WORKDIR /server
RUN cmake . -DBUILD_TOOLS=No -DCONF_INSTALL_DIR=/server/install/etc
RUN make ${THREAD_COUNT}
RUN make install ${THREAD_COUNT}




FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openssl libmariadbd19 libmariadb3

EXPOSE 3724
COPY --from=builder /server/install /server/install
WORKDIR /server/install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/server/install/lib

# Use a docker volume when running the image to populate this file:
CMD ["./launch.sh"]
