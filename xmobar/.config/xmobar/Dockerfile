FROM debian:12 AS build-stage

# copy configuration
RUN mkdir -p /root/.config/xmobar
WORKDIR /xmobar

RUN apt-get update && apt-get install -y git build-essential ghc cabal-install \
    curl libffi-dev libffi8 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 \
    xorg-dev libxrandr-dev libpango1.0-dev libasound2-dev libiw-dev libmpd-dev

RUN git clone --depth 1 --single-branch --branch 0.46 https://codeberg.org/xmobar/xmobar .

RUN cabal update && cabal install --only-dependencies

RUN cabal install --lib lib:xmobar

# COPY ./build /root/.config/xmobar/build
COPY ./xmobar.hs /root/.config/xmobar/xmobar.hs
RUN ghc --make /root/.config/xmobar/xmobar.hs

RUN ls -al /root/.config/xmobar/

FROM scratch AS export-stage
COPY --from=build-stage /root/.config/xmobar/xmobar ./bin/
