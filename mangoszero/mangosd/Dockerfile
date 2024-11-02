FROM debian:12 AS builder

ARG THREAD_COUNT="-j4"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git build-essential cmake openssl libssl-dev libmariadb-dev libmysql++-dev

WORKDIR /
RUN git clone https://github.com/mangoszero/server.git --recursive
WORKDIR /server
RUN cmake . -DBUILD_REALMD=No -DBUILD_TOOLS=No -DCONF_INSTALL_DIR=/server/install/etc
RUN apt-get install -y libreadline-dev
RUN make ${THREAD_COUNT}
RUN make install ${THREAD_COUNT}



FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openssl libmariadbd19 libmariadb3

EXPOSE 8085
COPY --from=builder /server/install /server/install
WORKDIR /server/install

RUN useradd -ms /bin/bash mangos
RUN mv etc/mangosd.conf.dist etc/mangosd.conf
RUN sed -i 's/^LoginDatabaseInfo *=.*$/LoginDatabaseInfo      = LOGIN_DATABASE_INFO/' etc/mangosd.conf
RUN sed -i 's/^WorldDatabaseInfo *=.*$/WorldDatabaseInfo      = WORLD_DATABASE_INFO/' etc/mangosd.conf
RUN sed -i 's/^CharacterDatabaseInfo *=.*$/CharacterDatabaseInfo      = CHARACTER_DATABASE_INFO/' etc/mangosd.conf
RUN chown -R mangos:mangos .
USER mangos

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/server/install/lib

COPY ./launch_mangosd.sh .

CMD ["./launch_mangosd.sh"]
