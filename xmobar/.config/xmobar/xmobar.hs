-- -*- mode: haskell; -*-

import Xmobar

config :: Config
config = defaultConfig {

  -- appearance
  font =         "MonaspiceXe Nerd Font 9"
  , additionalFonts = [ "AR PL UKai CN 11", "TsangerJinKai05 11", "LXGW WenKai Mono 11", "Symbols Nerd Font Mono 11", "monospace 9" ]
  , bgColor =      "#282c37"
  , fgColor =      "#abb2bf"
  , position =     TopSize L 100 30
  -- , border =       BottomB
  -- , borderColor =  "#eba0ac"

  -- layout
  , sepChar =  "%"   -- delineator between plugin names and straight text
  , alignSep = "}{"  -- separator between left-right alignment
  , template = "%UnsafeStdinReader% }{ \xf17c %kernel% | %uptime% | %multicpu% | %memory% | %disku% | %date% |  %_XMONAD_TRAYPAD%"

  -- general behavior
  , lowerOnStart =     True    -- send to bottom of window stack on start
  , hideOnStart =      False   -- start with window unmapped (hidden)
  , allDesktops =      True    -- show on all desktops
  , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
  , pickBroadest =     False   -- choose widest display (multi-monitor)
  , persistent =       True    -- enable/disable hiding (True = disabled)

  -- plugins
  --   Numbers can be automatically colored according to their value. xmobar
  --   decides color based on a three-tier/two-cutoff system, controlled by
  --   command options:
  --     --Low sets the low cutoff
  --     --High sets the high cutoff
  --
  --     --low sets the color below --Low cutoff
  --     --normal sets the color between --Low and --High cutoffs
  --     --High sets the color above --High cutoff
  --
  --   The --template option controls how the plugin is displayed. Text
  --   color can be set by enclosing in <fc></fc> tags. For more details
  --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
  , commands =

        -- weather monitor
        -- [ Run Weather "RJTT" [ "--template", "<skyCondition> | <fc=#4682B4><tempC></fc>°C | <fc=#4682B4><rh></fc>% | <fc=#4682B4><pressure></fc>hPa"
        --                      ] 36000

        -- network activity monitor (dynamic interface resolution)
        [ Run $ DynNetwork     [ "--template" , "\xfbf2 <rx>kB/s"
                             -- , "--Low"      , "1000"       -- units: B/s
                             -- , "--High"     , "5000"       -- units: B/s
                             -- , "--low"      , "darkgreen"
                             -- , "--normal"   , "darkorange"
                             -- , "--high"     , "darkred"
                             ] 10

        -- uptime monitor
        , Run $ Uptime         ["--template", "UP <days>d <hours>h <minutes>m <seconds>s"] 10

        -- kernel version
        , Run $ Com             "uname" ["-s","-r"] "kernel" 0

        -- cpu activity monitor
        , Run $ MultiCpu       [ "--template" , "CPU <total>%" ] 10

        -- cpu core temperature monitor
        -- , Run CoreTemp       [ "--template" , "Temp: <core0>°C|<core1>°C"
        --                      , "--Low"      , "70"        -- units: °C
        --                      , "--High"     , "80"        -- units: °C
        --                      , "--low"      , "darkgreen"
        --                      , "--normal"   , "darkorange"
        --                      , "--high"     , "darkred"
        --                      ] 50

        -- memory usage monitor
        , Run $ Memory         [ "--template" ,"MEM <usedratio>%(<used>MiB)"] 10

        -- battery monitor
        -- , Run $ Battery        [ "--template" , "<acstatus>"
        --                      , "--Low"      , "10"        -- units: %
        --                      , "--High"     , "80"        -- units: %
        --                      , "--low"      , "darkred"
        --                      , "--normal"   , "darkorange"
        --                      , "--high"     , "darkgreen"

        --                      , "--" -- battery specific options
        --                                -- discharging status
        --                                , "-o", "<left>% (<timeleft>)"
        --                                -- AC "on" status
        --                                , "-O", "<fc=#e2af42>Charging</fc>"
        --                                -- charged status
        --                                , "-i", "<fc=#407d52>Charged</fc>"
        --                      ] 50

        -- time and date indicator
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run $ Date           "%F %T %a" "date" 10

        -- keyboard layout indicator
        -- , Run $ Kbd            [ ("us(dvorak)" , "<fc=#932e23>DV</fc>")
        --                      , ("us"         , "<fc=#407d52>US</fc>")
        --                      ]

        , Run $ DiskU [("/", "\xf0a0 <used>")] ["-L", "20", "-H", "50", "-m", "1", "-p", "3"] 20

        , Run $ XPropertyLog   "_XMONAD_TRAYPAD"

        , Run UnsafeStdinReader
        ]
   }

main :: IO ()
main = xmobar config
