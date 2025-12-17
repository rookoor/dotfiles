# macOS Menu Bar Customization Research

Research into controlling the macOS menu bar appearance, specifically making it black to hide the notch while keeping light mode for the rest of the system.

**macOS Version:** Tahoe 26.2

## Goal

Make the menu bar black (to blend with the MacBook notch) while keeping the rest of the system in light mode.

## What We Discovered

### The Core Problem

The menu bar text color is **hard-coded to the system appearance**:
- Light mode = black text
- Dark mode = white text

There is no public (or private) API to set the menu bar text color independently.

### Private APIs Explored

#### SkyLight Framework (`/System/Library/PrivateFrameworks/SkyLight.framework`)

The SkyLight framework controls WindowServer and menu bar rendering. Key functions discovered:

```swift
// Get connection ID (required for most SLS calls)
@_silgen_name("CGSMainConnectionID")
func CGSMainConnectionID() -> Int32

// Control menu bar transparency - THIS WORKS!
@_silgen_name("SLSSetMenuBarInsetAndAlpha")
func SLSSetMenuBarInsetAndAlpha(_ cid: Int32, _ insetTop: Double, _ insetBottom: Double, _ alpha: Float) -> Int32

// These exist but don't visibly change anything
@_silgen_name("SLSSetMenuBarDrawingStyle")
func SLSSetMenuBarDrawingStyle(_ cid: Int32, _ style: Int32) -> Int32

@_silgen_name("SLSGetMenuBarDrawingStyle")
func SLSGetMenuBarDrawingStyle(_ cid: Int32, _ style: UnsafeMutablePointer<Int32>) -> Int32
```

#### HIToolbox (Carbon Framework)

```swift
@_silgen_name("_HIMenuBarSetAppearanceOverride")
func HIMenuBarSetAppearanceOverride(_ appearance: Int32) -> Void

@_silgen_name("_HIMenuBarGetAppearance")
func HIMenuBarGetAppearance() -> Int32
```

These functions exist but didn't produce visible changes in our testing.

### What Actually Works

#### 1. Alpha Control (Partial Success)

```swift
// Compile with: swiftc file.swift -framework AppKit -F/System/Library/PrivateFrameworks -framework SkyLight

import Foundation
import AppKit

@_silgen_name("CGSMainConnectionID")
func CGSMainConnectionID() -> Int32

@_silgen_name("SLSSetMenuBarInsetAndAlpha")
func SLSSetMenuBarInsetAndAlpha(_ cid: Int32, _ insetTop: Double, _ insetBottom: Double, _ alpha: Float) -> Int32

let cid = CGSMainConnectionID()

// Values:
// 1.0 = normal
// 0.5 = darker/more transparent
// 0.1 = very dark
// 0.0 = DISAPPEARS COMPLETELY (not just invisible - gone!)
_ = SLSSetMenuBarInsetAndAlpha(cid, 0, 0, 0.1)
```

**Result:** Makes the background darker, but text stays black (unreadable on dark background).

**Important:** Setting alpha to 0.0 makes the menu bar completely non-existent - you can click through it to the desktop!

#### 2. System Dark Mode

```bash
# Enable dark mode
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'

# Disable dark mode
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
```

**Result:** Makes menu bar gray (not true black) with white text on macOS Tahoe.

#### 3. Hybrid Mode (NSRequiresAquaSystemAppearance)

```bash
# Force apps to use light mode even when system is dark
defaults write -g NSRequiresAquaSystemAppearance -bool YES

# Then enable dark mode
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'

# To undo:
defaults delete -g NSRequiresAquaSystemAppearance
```

**Result:** On macOS Tahoe, this just looks like regular dark mode. The menu bar is gray, not black. Doesn't achieve the goal.

### Key Data Structures

```
SLSTransactionPerMenuBarData instance variables:
  - _fsMenuBarAppearance      <- Fullscreen appearance flag (BLACK menu bar!)
  - _reduceTransparency
  - _increasedContrast
  - _differentiateWithoutColor
  - _displayID
  - _spaceID
  - _reveal
  - _revealDuration
```

The `_fsMenuBarAppearance` flag controls the fullscreen black menu bar, but we couldn't find a way to set it outside of actual fullscreen mode.

### Interesting Constants Found

```
kSLSMenuBarUseFullScreenMenuBarAppearance  <- What we want, can't set it
kSLSMenuBarReduceTransparency
kSLSMenuBarIncreasedContrast
kSLSMenuBarDifferentiateWithoutColor
```

### How TopNotch App Works

TopNotch doesn't use private APIs - it simply **modifies your wallpaper** to add a ~74px black strip at the top. Since the menu bar is semi-transparent, it picks up the black from the wallpaper.

However, this doesn't change the text color. TopNotch only "works" because in dark mode the text is already white.

## Conclusions

1. **Text color cannot be changed independently** - it's tied to system light/dark mode
2. **Background transparency can be controlled** via `SLSSetMenuBarInsetAndAlpha`
3. **True black menu bar with white text** requires dark mode (no way around it)
4. **macOS Tahoe dark mode menu bar is gray**, not true black
5. **The fullscreen black menu bar** is controlled by an internal flag we can't set

## Potential Workarounds

1. **Accept dark mode** with `NSRequiresAquaSystemAppearance` to keep apps light
2. **Create an overlay app** that draws white text on top of the menu bar (very hacky)
3. **Use TopNotch** - accepts the limitation, just makes background black
4. **File a feature request** with Apple for independent menu bar appearance

## Tools Created

Located in `~/`:
- `menubar_read.swift` - reads all menu bar state values
- `menubar_set_alpha.swift` - sets menu bar alpha (persists until changed)
- `menubar_hold.swift` - continuously sets alpha (fights system resets)
- `menubar_test.swift` - various experiments

Compile with:
```bash
swiftc file.swift -o output -framework AppKit -F/System/Library/PrivateFrameworks -framework SkyLight
```

## References

- SkyLight framework: `/System/Library/PrivateFrameworks/SkyLight.framework`
- dyld shared cache: `/System/Volumes/Preboot/Cryptexes/OS/System/Library/dyld/dyld_shared_cache_arm64e`
- TopNotch app: https://topnotch.app/
- yabai (uses SkyLight APIs): https://github.com/koekeishiya/yabai
