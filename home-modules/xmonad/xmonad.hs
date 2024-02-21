import Control.Monad (join, when)
import Data.Map qualified as M
import Data.Maybe (maybeToList)
import Data.Monoid ()
import Graphics.X11.ExtraTypes.XF86
  ( xF86XK_AudioLowerVolume,
    xF86XK_AudioMute,
    xF86XK_AudioNext,
    xF86XK_AudioPlay,
    xF86XK_AudioPrev,
    xF86XK_AudioRaiseVolume,
    xF86XK_MonBrightnessDown,
    xF86XK_MonBrightnessUp,
  )
import System.Exit ()
import Text.Printf
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.InsertPosition (Focus (Newer), Position (Below), insertPosition)
import XMonad.Hooks.ManageDocks
  ( Direction2D (D, L, R, U),
    avoidStruts,
    docks,
    manageDocks,
  )
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Fullscreen
  ( FullscreenMessage (AddFullscreen, RemoveFullscreen),
    fullscreenEventHook,
    fullscreenFloat,
    fullscreenFull,
    fullscreenManageHook,
    fullscreenSupport,
  )
import XMonad.Layout.Gaps
  ( Direction2D (D, L, R, U),
    GapMessage (DecGap, IncGap, ToggleGaps),
    gaps,
    setGaps,
  )
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing (Border (Border), spacingRaw, toggleScreenSpacingEnabled)
import XMonad.Layout.Spiral
import XMonad.Layout.ToggleLayouts
import XMonad.StackSet qualified as W
import XMonad.Util.SpawnOnce (spawnOnce)

myTerminal = "wezterm"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth = 2

myModMask = mod4Mask

myWorkspaces = map show [1 .. 9]

myNormalBorderColor = "#000000"

myFocusedBorderColor = "#d6acff"

-- Infix (,) to clean up key and mouse bindings
infixr 0 ~>

(~>) :: a -> b -> (a, b)
(~>) = (,)

toggleFloat :: Window -> X ()
toggleFloat w =
  windows
    ( \s ->
        if M.member w (W.floating s)
          then W.sink w s
          else W.float w (W.RationalRect (1 / 3) (1 / 4) (1 / 2) (1 / 2)) s
    )

toggleFullscreen :: X ()
toggleFullscreen =
  withWindowSet $ \ws ->
    withFocused $ \w -> do
      let fullRect = W.RationalRect 0 0 1 1
      let isFullFloat = w `M.lookup` W.floating ws == Just fullRect
      windows $ if isFullFloat then W.sink w else W.float w fullRect

myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- launch a terminal
    [ (modm, xK_Return) ~> spawn $ XMonad.terminal conf,
      -- lock screen
      (modm, xK_l) ~> spawn "xset s activate",
      -- launch browser
      (modm, xK_w) ~> spawn "firefox",
      -- Color picker
      (modm, xK_c) ~> spawn "color",
      -- rofi menus
      (modm, xK_space) ~> spawn "rofi -show drun",
      (modm .|. shiftMask, xK_BackSpace) ~> spawn "power-menu",
      (modm, xK_e) ~> spawn "rofi -show emoji",
      (modm, xK_b) ~> spawn "rofi-bluetooth",
      -- launch file manager
      (modm, xK_r) ~> spawn (myTerminal ++ " -e yazi"),
      (modm .|. shiftMask, xK_r) ~> spawn "pcmanfm",
      -- Audio keys
      (0, xF86XK_AudioPlay) ~> spawn "playerctl play-pause",
      (0, xF86XK_AudioPrev) ~> spawn "playerctl previous",
      (0, xF86XK_AudioNext) ~> spawn "playerctl next",
      (modm, xK_slash) ~> spawn "playerctl play-pause",
      (modm, xK_comma) ~> spawn "playerctl previous",
      (modm, xK_period) ~> spawn "playerctl next",
      (0, xF86XK_AudioRaiseVolume) ~> spawn "audio-control up 10%",
      (0, xF86XK_AudioLowerVolume) ~> spawn "audio-control down 10%",
      (0, xF86XK_AudioMute) ~> spawn "audio-control mute",
      -- Brightness keys
      (0, xF86XK_MonBrightnessUp) ~> spawn "brightnessctl s +10%",
      (0, xF86XK_MonBrightnessDown) ~> spawn "brightnessctl s 10%-",
      -- close focused window
      (modm, xK_q) ~> kill,
      -- GAPS!!!
      (modm .|. controlMask, xK_g) ~> sendMessage ToggleGaps, -- toggle all gaps
      (modm .|. shiftMask, xK_g) ~> sendMessage $ setGaps [(L, outerGap), (R, outerGap), (U, outerGap), (D, outerGap)], -- reset the GapSpec
      (modm .|. controlMask, xK_t) ~> sendMessage $ IncGap 10 L, -- increment the left-hand gap
      (modm .|. shiftMask, xK_t) ~> sendMessage $ DecGap 10 L, -- decrement the left-hand gap
      (modm .|. controlMask, xK_y) ~> sendMessage $ IncGap 10 U, -- increment the top gap
      (modm .|. shiftMask, xK_y) ~> sendMessage $ DecGap 10 U, -- decrement the top gap
      (modm .|. controlMask, xK_u) ~> sendMessage $ IncGap 10 D, -- increment the bottom gap
      (modm .|. shiftMask, xK_u) ~> sendMessage $ DecGap 10 D, -- decrement the bottom gap
      (modm .|. controlMask, xK_i) ~> sendMessage $ IncGap 10 R, -- increment the right-hand gap
      (modm .|. shiftMask, xK_i) ~> sendMessage $ DecGap 10 R, -- decrement the right-hand gap

      -- Toggle Full Screen
      (modm .|. shiftMask, xK_f) ~> toggleFullscreen,
      -- Rotate through the available layout algorithms
      (modm, xK_n) ~> sendMessage NextLayout,
      --  Reset the layouts on the current workspace to default
      (modm .|. shiftMask, xK_n) ~> setLayout $ XMonad.layoutHook conf,
      -- Move focus to the next window
      (modm, xK_j) ~> windows W.focusDown,
      -- Move focus to the previous window
      (modm, xK_k) ~> windows W.focusUp,
      -- Move focus to the master window
      (modm, xK_m) ~> windows W.focusMaster,
      -- Swap the focused window and the master window
      (modm, xK_f) ~> windows W.swapMaster,
      -- Swap the focused window with the next window
      (modm .|. shiftMask, xK_j) ~> windows W.swapDown,
      -- Swap the focused window with the previous window
      (modm .|. shiftMask, xK_k) ~> windows W.swapUp,
      -- Shrink the master area
      (modm .|. shiftMask, xK_h) ~> sendMessage Shrink,
      -- Expand the master area
      (modm .|. shiftMask, xK_l) ~> sendMessage Expand,
      -- Push window back into tiling
      (modm, xK_t) ~> withFocused toggleFloat,
      -- Increment the number of windows in the master area
      (modm .|. shiftMask, xK_comma) ~> sendMessage (IncMasterN 1),
      -- Deincrement the number of windows in the master area
      (modm .|. shiftMask, xK_period) ~> sendMessage (IncMasterN (-1)),
      -- Restart xmonad
      (modm .|. shiftMask, xK_q) ~> spawn "xmonad --restart",
      -- Take a screenshot
      (modm .|. shiftMask, xK_s) ~> spawn "flameshot gui",
      (0, xK_Print) ~> spawn "flameshot gui"
    ]
      ++
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      [ (m .|. modm, k) ~> windows $ f i
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
      ++
      -- mod-{[,]}, Switch to physical/Xinerama screens 1 or 2
      -- mod-shift-{[,]}, Move client to screen 1 or 2
      [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_braceleft, xK_braceright] [0 ..],
          (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      ]

myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w ->
          focus w
            >> mouseMoveWindow w
            >> windows W.shiftMaster
      )
    ]

myManageHook :: ManageHook
myManageHook =
  fullscreenManageHook
    <+> composeAll
      [ fmap not willFloat --> insertPosition Below Newer,
        isFullscreen --> doFullFloat
      ]

myLayout = avoidStruts (tiled ||| GridRatio (21 / 9) ||| spiral (21 / 9) ||| Mirror tiled)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2
    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

outerGap = 0

myLayoutHook =
  spacingRaw
    False
    (Border 10 10 10 10)
    True
    (Border 10 10 10 10)
    True
    $ smartBorders
      myLayout

toggleStrutsKey XConfig {XMonad.modMask = modm} = (modm, xK_b)

main :: IO ()
main =
  xmonad
    . ewmhFullscreen
    . ewmh
    . withEasySB (statusBarProp "polybar -c ~/.config/polybar/config.ini" (pure def)) toggleStrutsKey
    $ myConfig

myConfig =
  def
    { -- simple stuff
      terminal = myTerminal,
      focusFollowsMouse = myFocusFollowsMouse,
      clickJustFocuses = myClickJustFocuses,
      borderWidth = myBorderWidth,
      modMask = myModMask,
      workspaces = myWorkspaces,
      normalBorderColor = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,
      keys = myKeys,
      layoutHook = myLayoutHook,
      manageHook = myManageHook
    }
