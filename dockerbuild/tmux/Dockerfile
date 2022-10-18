FROM debian:12 AS build-stage
ENV VERSION=3.4
RUN apt-get update && apt-get install -y libevent-dev ncurses-dev build-essential bison pkg-config wget
RUN wget https://github.com/tmux/tmux/releases/download/$VERSION/tmux-$VERSION.tar.gz
RUN tar -zxf tmux-$VERSION.tar.gz
RUN (cd tmux-$VERSION/ && ./configure --enable-static && make && make install)

FROM scratch AS export-stage
COPY --from=build-stage /usr/local/bin/tmux ./build/tmux

