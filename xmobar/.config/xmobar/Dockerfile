FROM debian:12 AS build-stage

# copy configuration
RUN mkdir -p /root/.config/xmobar
WORKDIR /root/.config/xmobar

RUN apt-get update && apt-get install -y git build-essential haskell-stack \
    xorg-dev libxrandr-dev libpango1.0-dev libasound2-dev libiw-dev libmpd-dev

RUN git clone --depth 1 --single-branch --branch 0.46 https://codeberg.org/xmobar/xmobar /root/.config/xmobar/xmobar-git

RUN stack upgrade
RUN stack setup
RUN stack init
RUN echo '\n\
extra-deps: \n\
  - netlink-1.1.1.0 \n\
  - iwlib-0.1.0 \n'\
>> /root/.config/xmobar/stack.yaml
RUN cat /root/.config/xmobar/stack.yaml
RUN LANG=C stack install --flag xmobar:with_xpm

COPY ./build /root/.config/xmobar/build
COPY ./xmobar.hs /root/.config/xmobar/xmobar.hs

# build xmobar cache
# xmobar recompile will continue run itself, this will error
RUN timeout 10s /root/.local/bin/xmobar --recompile -v; exit 0

RUN ls -al
RUN ls -al /root/.local/bin

FROM scratch AS export-stage
COPY --from=build-stage /root/.local/bin/xmobar ./bin/
COPY --from=build-stage /root/.config/xmobar/xmobar-x86_64-linux ./bin/
