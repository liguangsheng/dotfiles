#!/bin/sh
(cd dmenu  && rm -f config.h && sudo make install clean)
(cd dwm    && rm -f config.h && sudo make install clean)
(cd st     && rm -f config.h && sudo make install clean)
(cd scroll && rm -f config.h && sudo make install clean)
(cd tabbed && rm -f config.h && sudo make install clean)
