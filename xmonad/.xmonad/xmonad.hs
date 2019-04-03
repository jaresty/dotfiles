import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.Dwindle

myLayouts = Dwindle R CW 1.5 1.1
            ||| Full

main = do
  xmonad =<< xmobar (defaultConfig
    { terminal = myTerminal
    , modMask = myModMask
    , borderWidth = myBorderWidth
    , layoutHook = myLayouts
    })

myTerminal = "alacritty"
myModMask = mod4Mask
myBorderWidth = 3
