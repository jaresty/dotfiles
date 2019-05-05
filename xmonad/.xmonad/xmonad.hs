import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.Dwindle
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Hooks.FadeInactive (fadeInactiveLogHook)
import XMonad.Layout.Spacing (smartSpacing)
import XMonad.Actions.CycleWS
import XMonad.Util.Run
import XMonad.Util.EZConfig ( additionalKeysP )
import XMonad.Util.Replace
import XMonad.Actions.DynamicWorkspaces
import XMonad.Prompt (def)
import XMonad.Util.NamedScratchpad
import Data.Ratio
import Data.List
import XMonad.Hooks.ManageHelpers (doRectFloat)
import qualified XMonad.StackSet as W
import qualified Data.Map as M

scratchpads = [
  NS "devdocs-desktop" "devdocs-desktop" (title =? "DevDocs") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "zoom" "zoom" (fmap ("Zoom Meeting ID" `isInfixOf`) title) (customFloating (W.RationalRect (5/6) (5/6) (1/6) (1/6)))
  , NS "tracker" "start-tracker" (appName =? "pivotaltracker.com") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "cloudfoundry-slack" "start-cloudfoundry-slack" (appName =? "cloudfoundry.slack.com") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "pivotal-slack" "start-pivotal-slack" (appName =? "pivotal.slack.com") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "google-keep" "start-google-keep" (appName =? "keep.google.com") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "google-docs" "start-google-docs" (appName =? "docs.google.com") nonFloating
  , NS "qutebrowser" "qutebrowser" (appName =? "qutebrowser") nonFloating
 ]

myLayouts = smartSpacing 5 $ Dwindle R CW 1.5 1.1
            ||| Full

myKeys = [ ("M-p", spawn "rofi -show run")
  , ("M1-C-h", spawn "rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'")
  , ("M-S-4", spawn "flameshot gui")
  , ("M-S-<Backspace>", removeWorkspace)
  , ("M-S-v", selectWorkspace def)
  , ("M-S-m", withWorkspace def (windows . W.shift))
  , ("M-S-r", renameWorkspace def)
  , ("M-0", toggleWS)
  , ("M-d", namedScratchpadAction scratchpads "devdocs-desktop")
  , ("M-z", namedScratchpadAction scratchpads "zoom")
  , ("M-S-t", namedScratchpadAction scratchpads "tracker")
  , ("M-s", namedScratchpadAction scratchpads "cloudfoundry-slack")
  , ("M-S-s", namedScratchpadAction scratchpads "pivotal-slack")
  , ("M-b", namedScratchpadAction scratchpads "qutebrowser")
  , ("M-n", namedScratchpadAction scratchpads "google-keep")
  , ("M-S-d", namedScratchpadAction scratchpads "google-docs")
  , ("M-<Down>", nextWS)
  , ("M-<Up>", prevWS)
  , ("M-S-<Down>", shiftToNext >> nextWS)
  , ("M-S-<Up>", shiftToPrev >> prevWS)
  , ("M-<Right>", nextScreen)
  , ("M-<Left>", prevScreen)
  , ("M-S-<Right>", shiftNextScreen)
  , ("M-S-<Left>", shiftPrevScreen)
 ]

myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "[" "]" }
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_a)
myManageHook = composeAll
 [
   (className =? "zoom") --> (customFloating (W.RationalRect (5/6) (1/12) (1/6) (2/6)))
   -- (className =? "pivotaltracker.com") --> (customFloating (W.RationalRect (5/6) (1/12) (1/6) (2/6)))
 ]

myConfig = defaultConfig
  { terminal = myTerminal
  , modMask = myModMask
  , borderWidth = myBorderWidth
  , layoutHook = smartBorders $ myLayouts
  , logHook =  fadeInactiveLogHook 0.8
  , focusedBorderColor = background
  , normalBorderColor = color8
  , manageHook = myManageHook <+> namedScratchpadManageHook scratchpads <+> manageHook def
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
