-- -*- mode: haskell -*-
-- {# LANGUAGE UnicodeSyntax #-}

import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import Text.Printf

import XMonad
import XMonad.Actions.TiledWindowDragging
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.DraggingVisualizer
import XMonad.Layout.Grid
import XMonad.Layout.Maximize
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.Cursor
import XMonad.Util.EZConfig (additionalKeysP, additionalKeys, additionalMouseBindings)
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import qualified XMonad.Util.Hacks as Hacks

colorPrim     = "#bd84f7"
colorBg       = "#282c37"
colorGrey     = "#484854"
myTerminal    = "alacritty"
myRofiDrunCmd = printf "rofi -show drun -theme-str '*{primary:%s;background:%s;}'" colorPrim colorBg
myRofiRunCmd  = printf "rofi -show run -theme-str '*{primary:%s;background:%s;}'" colorPrim colorBg
myWorkspaces  = ["一", "二", "三", "四", "五", "六", "七", "八", "九"]

myLayouts =
  renamed [CutWordsLeft 3]
  $ maximize
  $ draggingVisualizer
  $ spacingRaw False (Border 3 3 3 3) True (Border 3 3 3 3) True
  $ avoidStruts
  $ Tall 1 (3/100) (1/2)
  ||| ThreeCol 1 (3/100) (1/2)
  ||| Grid
  ||| spiral (6/7)
  ||| Full

myKeysP =
  -- XMonad Keys
  [ ("M-C-q", io exitSuccess)
  , ("M-C-r", spawn "xmonad --restart")

  -- Window Keys
  , ("M-C-h", sendMessage Shrink)
  , ("M-C-l", sendMessage Expand)
  , ("M-C-i", sendMessage (IncMasterN (1)))
  , ("M-C-d", sendMessage (IncMasterN (-1)))

  -- Application Keys
  , ("M-S-<Return>", spawn (myTerminal))
  , ("M-S-p",        spawn (myRofiRunCmd))
  , ("M-p",          spawn (myRofiDrunCmd))
  ]

myKeys =
  [ ((mod4Mask, xK_m), withFocused (sendMessage . maximizeRestore))
  ]

myMouseBindings =
  [ ((mod4Mask .|. shiftMask, button1), dragWindow)
  ]

xmobarFont :: Int -> String -> String
xmobarFont n = wrap (printf "<fn=%d>" n) "</fn>"

main :: IO()
main = do
  xmproc <- spawnPipe "/home/lgs/.local/bin/xmobar"
  xmonad $ docks $ ewmh $ ((def {
    modMask              = mod4Mask
    , workspaces         = myWorkspaces
    , terminal           = myTerminal
    , borderWidth        = 2
    , normalBorderColor  = colorGrey
    , focusedBorderColor = colorPrim
    , layoutHook         = myLayouts

    , manageHook = manageDocks <+> composeAll
      [ className =? "trayer"       --> doIgnore
      , className =? "stalonetray"  --> doIgnore]

    , startupHook = do
        setDefaultCursor xC_left_ptr

    -- hack for stalonetray, need xmonad-contrib-0.17.0.9
    , handleEventHook = handleEventHook def <> Hacks.trayPaddingXmobarEventHook (className =? "stalonetray") "_XMONAD_TRAYPAD"
    -- hack for trayer
    -- , handleEventHook = handleEventHook def <> Hacks.trayerAboveXmobarEventHook

    , logHook = clickablePP xmobarPP {
        ppOutput            = hPutStrLn xmproc
        , ppSep             = " | "
        , ppWsSep           = " "
        -- 当前工作区
        , ppCurrent         = xmobarColor colorPrim "" . xmobarFont 1 . wrap "[" "]"
        -- 可见但是没有焦点的工作区
        , ppVisible         = xmobarColor "grey" ""
        -- 有窗口但是没有焦点的工作区
        , ppHidden          = xmobarColor colorPrim "" . xmobarFont 1
        -- 没窗口没焦点的工作区
        , ppHiddenNoWindows = xmobarColor "grey" "" . xmobarFont 1
        -- 当前窗口标题
        , ppTitle           = xmobarColor colorPrim ""
      } >>= dynamicLogWithPP
  })
                              `additionalKeysP` myKeysP
                              `additionalKeys` myKeys
                              `additionalMouseBindings` myMouseBindings)

