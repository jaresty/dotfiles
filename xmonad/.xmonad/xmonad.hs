import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeys)

main = do
  xmonad =<< xmobar (defaultConfig
    { terminal = myTerminal
    , modMask = myModMask
    , borderWidth = myBorderWidth
    }
    `additionalKeys` [])

myTerminal = "alacritty"
myModMask = mod4Mask
myBorderWidth = 3
