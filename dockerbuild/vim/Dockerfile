FROM debian:bullseye AS build-stage

RUN apt-get update 
RUN apt-get install -y git && git clone --branch v9.0.1396 https://github.com/vim/vim.git /root/vim 
RUN apt-get install -y \
    make \
    gcc \
    libgpm-dev \
    libacl1-dev \
    ncurses-dev libncurses5-dev \
    libxt-dev \
    libperl-dev \
    python-dev python3-dev \
    lua5.3 liblua5.3-dev luajit libluajit-5.1 \
    ruby-dev \
    tcl-dev \
    libssl-dev \
    libgcrypt20-dev \
    libcanberra-dev

RUN (cd /root/vim \
    && ./configure \
    --prefix=/usr/local \
    --with-features=huge \
    --with-compiledby=liguangsheng \
    --enable-gpm \
    --enable-acl \
    --with-x=yes \
    --disable-gui \
    --enable-multibyte \
    --enable-cscope \
    --enable-netbeans \
    --enable-perlinterp=dynamic \
    --enable-python3interp=dynamic \
    --enable-rubyinterp=dynamic \
    --enable-luainterp=dynamic \
    --enable-tclinterp=dynamic \
    --disable-canberra \
    --with-clipboard=yes \
    && make)

FROM scratch AS export-stage
COPY --from=build-stage /root/vim ./build
