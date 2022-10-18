FROM debian:12 AS build-stage

WORKDIR /root/.config/xmonad

RUN apt-get update && apt-get install -y git build-essential libx11-dev libxft-dev libxinerama-dev libxrandr-dev libxss-dev haskell-stack
RUN git clone --branch v0.18.0 https://github.com/xmonad/xmonad /root/.config/xmonad/xmonad-git
RUN git clone --branch v0.18.0 https://github.com/xmonad/xmonad-contrib /root/.config/xmonad/xmonad-contrib-git
RUN stack upgrade
RUN stack init
RUN stack install
RUN cat stack.yaml

COPY ./build /root/.config/xmonad/build
COPY ./xmonad.hs /root/.config/xmonad/xmonad.hs
RUN /root/.local/bin/xmonad --recompile

FROM scratch AS export-stage
COPY --from=build-stage /root/.cache/xmonad/xmonad-x86_64-linux ./bin/
COPY --from=build-stage /root/.local/bin/xmonad ./bin/
