FROM haskell:9.2.7 AS build-stage

RUN mkdir -p /root/.config/xmonad
WORKDIR /root/.config/xmonad

RUN apt-get update && apt-get install -y libx11-dev libxft-dev libxinerama-dev libxrandr-dev libxss-dev haskell-stack

RUN git clone --branch v0.17.2 https://github.com/xmonad/xmonad /root/.config/xmonad/xmonad-git
RUN git clone --branch v0.17.1 https://github.com/xmonad/xmonad-contrib /root/.config/xmonad/xmonad-contrib-git

RUN stack setup
RUN stack init
RUN stack install

COPY ./build /root/.config/xmonad/build
COPY ./xmonad.hs /root/.config/xmonad/xmonad.hs
RUN xmonad --recompile

FROM scratch AS export-stage
COPY --from=build-stage /root/.cache/xmonad/xmonad-x86_64-linux ./bin/
COPY --from=build-stage /root/.local/bin/xmonad ./bin/
