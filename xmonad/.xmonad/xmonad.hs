import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.Dwindle
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Hooks.FadeInactive (fadeInactiveLogHook)
import XMonad.Layout.Spacing (smartSpacing)
import XMonad.Actions.CycleWS (toggleWS)
import XMonad.Util.Run
import XMonad.Util.EZConfig ( additionalKeysP )
import XMonad.Util.Replace
import XMonad.Actions.DynamicWorkspaces
import XMonad.Prompt (def)
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W
import qualified Data.Map as M

scratchpads = [
  NS "devdocs-desktop" "devdocs-desktop" (className =? "devdocs") defaultFloating,
  NS "htop" "alacritty -e htop" (title =? "htop") defaultFloating
 ]

myLayouts = smartSpacing 5 $ Dwindle R CW 1.5 1.1
            ||| Full

myKeys = [ ("M-p", spawn "rofi -show run")
  , ("M1-C-h", spawn "rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'")
  , ("M-S-4", spawn "flameshot gui")
  , ("M-S-<Backspace>", removeWorkspace)
  , ("M-S-v", selectWorkspace def)
  , ("M-m", withWorkspace def (windows . W.shift))
  , ("M-S-r", renameWorkspace def)
  , ("M-0", toggleWS)
  , ("M-d", namedScratchpadAction scratchpads "devdocs-desktop")
  , ("M-t", namedScratchpadAction scratchpads "htop")
 ]

myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "[" "]" }
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
myConfig = defaultConfig
  { terminal = myTerminal
  , modMask = myModMask
  , borderWidth = myBorderWidth
  , layoutHook = smartBorders $ myLayouts
  , logHook =  fadeInactiveLogHook 0.8
  , focusedBorderColor = background
  , normalBorderColor = color8
  , manageHook = namedScratchpadManageHook scratchpads <+> manageHook defaultConfig
  } `additionalKeysP` myKeys

main = do
  compton <- spawnPipe "compton --config ~/.config/compton.conf"
  greenclip <- spawnPipe "greenclip daemon"
  xmonad =<< statusBar "xmobar" myPP toggleStrutsKey myConfig

myTerminal = "alacritty"
myModMask = mod4Mask
myBorderWidth = 0
background= "#232323"
color8= "#676767"
-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"
themeBackground = "#3c3b37"
themeHighlight  = "#f07746"
