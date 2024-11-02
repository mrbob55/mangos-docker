FROM debian:12 AS builder

ARG THREAD_COUNT="-j4"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git build-essential cmake openssl libssl-dev libmariadb-dev libmariadbd19 libmariadb3 libmysql++-dev

WORKDIR /
RUN git clone https://github.com/mangoszero/server.git --recursive
WORKDIR /server
RUN cmake . -DBUILD_MANGOSD=No -DBUILD_TOOLS=No -DCONF_INSTALL_DIR=/server/install/etc/
RUN make ${THREAD_COUNT}
RUN make install ${THREAD_COUNT}




FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openssl libmariadbd19 libmariadb3

EXPOSE 3724
COPY --from=builder /server/install /server/install
WORKDIR /server/install

RUN useradd -ms /bin/bash realm
RUN mv etc/realmd.conf.dist etc/realmd.conf
RUN sed -i 's/^LoginDatabaseInfo *=.*$/LoginDatabaseInfo      = LOGIN_DATABASE_INFO/' etc/realmd.conf
RUN chown -R realm:realm .
USER realm

COPY ./launch_realmd.sh .

CMD ["./launch_realmd.sh"]
