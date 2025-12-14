#!/usr/bin/env swift
// hjkl-arrows: Remap Cmd+HJKL to Arrow Keys
// Lightweight alternative to Karabiner using CGEventTap
// Requires Accessibility permissions
//
// Compile: swiftc -O -o hjkl-arrows hjkl-arrows.swift
// Run: ./hjkl-arrows

import Cocoa
import Foundation

// Key codes (from Events.h)
let kVK_ANSI_H: Int64 = 0x04
let kVK_ANSI_J: Int64 = 0x26
let kVK_ANSI_K: Int64 = 0x28
let kVK_ANSI_L: Int64 = 0x25
let kVK_LeftArrow: Int64 = 0x7B
let kVK_DownArrow: Int64 = 0x7D
let kVK_UpArrow: Int64 = 0x7E
let kVK_RightArrow: Int64 = 0x7C

// Mapping: HJKL -> Arrow keys
let remapTable: [Int64: Int64] = [
    kVK_ANSI_H: kVK_LeftArrow,
    kVK_ANSI_J: kVK_DownArrow,
    kVK_ANSI_K: kVK_UpArrow,
    kVK_ANSI_L: kVK_RightArrow
]

// Check for accessibility permissions
func checkAccessibility() -> Bool {
    let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
    return AXIsProcessTrustedWithOptions(options as CFDictionary)
}

// Event tap callback
func eventCallback(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    refcon: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {

    // Handle tap disabled (system can disable if too slow)
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        if let tap = refcon?.assumingMemoryBound(to: CFMachPort.self).pointee {
            CGEvent.tapEnable(tap: tap, enable: true)
        }
        return Unmanaged.passUnretained(event)
    }

    // Only process keyDown and keyUp
    guard type == .keyDown || type == .keyUp else {
        return Unmanaged.passUnretained(event)
    }

    let keycode = event.getIntegerValueField(.keyboardEventKeycode)
    let flags = event.flags

    // Check if Cmd is held (but not Cmd+Shift, Cmd+Opt, etc. for flexibility)
    let cmdOnly = flags.contains(.maskCommand) &&
                  !flags.contains(.maskControl) &&
                  !flags.contains(.maskAlternate)

    if cmdOnly, let arrowKey = remapTable[keycode] {
        // Remap to arrow key, remove Cmd modifier
        event.setIntegerValueField(.keyboardEventKeycode, value: arrowKey)
        event.flags = flags.subtracting(.maskCommand)

        // Add Shift if it was held (for selection)
        if flags.contains(.maskShift) {
            event.flags.insert(.maskShift)
        }
    }

    return Unmanaged.passUnretained(event)
}

// Main
func main() {
    print("hjkl-arrows: Cmd+HJKL → Arrow Keys")
    print("Press Ctrl+C to quit\n")

    // Check accessibility
    guard checkAccessibility() else {
        print("Error: Accessibility permission required")
        print("Grant permission in: System Settings → Privacy & Security → Accessibility")
        exit(1)
    }
    print("✓ Accessibility permission granted")

    // Create event tap
    let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)

    var tapRef: CFMachPort?
    tapRef = CGEvent.tapCreate(
        tap: .cghidEventTap,
        place: .headInsertEventTap,
        options: .defaultTap,
        eventsOfInterest: CGEventMask(eventMask),
        callback: eventCallback,
        userInfo: &tapRef
    )

    guard let tap = tapRef else {
        print("Error: Failed to create event tap")
        print("Try running with sudo or check permissions")
        exit(1)
    }
    print("✓ Event tap created")

    // Add to run loop
    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    CGEvent.tapEnable(tap: tap, enable: true)

    print("✓ Active: Cmd+H/J/K/L → ←/↓/↑/→")
    print("  (Cmd+Shift+HJKL works for selection)\n")

    // Run forever
    CFRunLoopRun()
}

main()
