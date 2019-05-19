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

zoomDimensions = (customFloating (W.RationalRect (3/4) (1/12) (1/4) (1/3)))
scratchpads = [
  NS "devdocs-desktop" "devdocs-desktop" (title =? "DevDocs") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "zoom" "zoom" (fmap ("Zoom Meeting ID" `isInfixOf`) title) zoomDimensions
  , NS "tracker" "start-tracker" (appName =? "pivotaltracker.com") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "cloudfoundry-slack" "start-cloudfoundry-slack" (appName =? "cloudfoundry.slack.com") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "slack" "slack" (appName =? "slack") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "google-keep" "start-google-keep" (appName =? "keep.google.com") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "google-docs" "start-google-docs" (appName =? "docs.google.com") nonFloating
  , NS "concourse" "start-concourse" (appName =? "main.bosh-ci.cf-app.com") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "miro" "start-miro" (appName =? "miro.com") nonFloating
  , NS "music" "start-music" (appName =? "music.youtube.com__watch") (customFloating (W.RationalRect (1/6) (1/6) (2/3) (2/3)))
  , NS "qutebrowser" "qutebrowser" (appName =? "qutebrowser") nonFloating
 ]

myLayouts = smartSpacing 5 $ Dwindle R CW 1.5 1.1
            ||| Full

myKeys = [ ("M-p", spawn "rofi -show run")
  , ("M1-C-v", spawn "rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'")
  , ("M-S-4", spawn "flameshot gui")
  , ("M-S-<Backspace>", removeWorkspace)
  , ("M-S-v", selectWorkspace def)
  , ("M-S-m", withWorkspace def (windows . W.shift))
  , ("M-S-r", renameWorkspace def)
  , ("M-0", toggleWS)

  , ("M1-d", namedScratchpadAction scratchpads "devdocs-desktop")
  , ("M1-z", namedScratchpadAction scratchpads "zoom")
  , ("M1-c", namedScratchpadAction scratchpads "concourse")
  , ("M1-t", namedScratchpadAction scratchpads "tracker")
  , ("M1-S-s", namedScratchpadAction scratchpads "slack")
  , ("M1-S-b", namedScratchpadAction scratchpads "qutebrowser")
  , ("M1-S-k", namedScratchpadAction scratchpads "google-keep")
  , ("M1-S-d", namedScratchpadAction scratchpads "google-docs")
  , ("M1-m", namedScratchpadAction scratchpads "miro")
  , ("M1-S-m", namedScratchpadAction scratchpads "music")

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
   (className =? "zoom") --> zoomDimensions
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
  dunst <- spawnPipe "dunst"
  flameshot <- spawnPipe "flameshot"
  polkit <- spawnPipe "/usr/lib/polkit-kde-authentication-agent-1"
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
