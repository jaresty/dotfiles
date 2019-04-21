import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.Dwindle
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Hooks.FadeInactive (fadeInactiveLogHook)
import XMonad.Layout.Spacing (smartSpacing)
import XMonad.Util.Run

myLayouts = smartSpacing 5 $ Dwindle R CW 1.5 1.1
            ||| Full


main = do
  xmproc <- spawnPipe "xmobar ~/.xmobar/xmobar-single.hs"
  xmonad =<< xmobar (defaultConfig
    { terminal = myTerminal
    , modMask = myModMask
    , borderWidth = myBorderWidth
    , layoutHook = smartBorders $ myLayouts
    , logHook = fadeInactiveLogHook 0.7
    , focusedBorderColor = background
    , normalBorderColor = color8
    })

myTerminal = "alacritty"
myModMask = mod4Mask
myBorderWidth = 3
background= "#232323"
color8= "#676767"
-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"
