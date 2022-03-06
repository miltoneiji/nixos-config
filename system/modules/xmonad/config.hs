import XMonad
import System.Exit (exitSuccess)
import Data.Monoid
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutModifier
import XMonad.Actions.TopicSpace
import XMonad.Layout.MultiToggle (mkToggle, single)
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL))
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Util.SpawnOnce
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
  ( docksEventHook
  , avoidStruts
  , docks
  )
import XMonad.Hooks.ManageHelpers (doFullFloat, isFullscreen)

-- Imports for Polybar --
import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus as D
import qualified DBus.Client as D
import XMonad.Hooks.DynamicLog

------------------------------
-- LOG HOOK ------------------
------------------------------
mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
  where
  opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath = D.objectPath_ "/org/xmonad/Log"
      iname = D.interfaceName_ "org.xmonad.Log"
      mname = D.memberName_ "Update"
      signal = (D.signal opath iname mname)
      body = [D.toVariant $ UTF8.decodeString str]
  in D.emit dbus $ signal { D.signalBody = body }

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      red        = "#FF0000"
      primary    = "#1681F2"
      foreground = "#FBFBFB"
      faded      = "#666666"
  in def { ppOutput          = dbusOutput dbus
         , ppCurrent         = wrapper primary
         , ppVisible         = wrapper faded
         , ppUrgent          = wrapper red
         , ppHidden          = wrapper foreground
         , ppHiddenNoWindows = wrapper faded
         , ppTitle           = shorten 60 . wrapper foreground
         }

myPolybarLogHook dbus = dynamicLogWithPP (polybarHook dbus)

------------------------------
-- KEYS ----------------------
------------------------------
myKeys :: [([Char], X ())]
myKeys =
  [ -- Essentials
    ("M-<Return>", spawn "kitty")
  , ("M-d", spawn "$HOME/.scripts/programs")
  , ("M-S-q", io exitSuccess)
  , ("M-q", kill1)
  , ("M-j", windows W.focusDown)
  , ("M-k", windows W.focusUp)
  , ("M-w", windows W.swapMaster)
  , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  ]

------------------------------
-- WORKSPACES ----------------
------------------------------
myWorkspaces :: [Topic]
myWorkspaces = ["1", "2", "3", "4"]

------------------------------
-- LAYOUT --------------------
------------------------------
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall = renamed [Replace "tall"] $ mySpacing 5 $ ResizableTall 1 (3 / 100) (1 / 2) []
full = renamed [Replace "full"] $ Full

myLayoutHook = avoidStruts $ mkToggle (single NBFULL) $ tall ||| full

------------------------------
-- MANAGEHOOK ----------------
------------------------------
myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook =
  composeAll
  [ isFullscreen --> doFullFloat ]

------------------------------
-- EVENT HOOK ----------------
------------------------------
myEventHook = docksEventHook <+> ewmhDesktopsEventHook <+> fullscreenEventHook

------------------------------
-- STARTUP HOOK --------------
------------------------------
myStartupHook = do
  spawnOnce "systemctl --user enable --now polybar.service"

------------------------------
-- MAIN ----------------------
------------------------------
main :: IO ()
main = mkDbusClient >>= main'

main' :: D.Client -> IO ()
main' dbus = xmonad . docks . ewmh $ def
  { terminal           = "kitty"
  , focusFollowsMouse  = True
  , clickJustFocuses   = True
  , borderWidth        = 3
  , modMask            = mod4Mask
  , workspaces         = myWorkspaces
  , normalBorderColor  = "#DDDDDD"
  , focusedBorderColor = "#1681F2"
  , layoutHook         = myLayoutHook
  , manageHook         = myManageHook
  , handleEventHook    = myEventHook
  , startupHook        = myStartupHook
  , logHook            = myPolybarLogHook dbus
  } `additionalKeysP` myKeys
