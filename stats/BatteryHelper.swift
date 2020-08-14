//
//  Battery.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation


// MARK: - Battery

/// Since mac minis and mac pro have no batteries I can skip this for now
/// Output: `"battery":[]`
func getBattery() -> [String] {
  /// Will not be implemented for now since it's only for macOS
  /// When we do this for mobile/tvOS/watchOS we can then add this
  var battery = Battery()
  if battery.open() != kIOReturnSuccess {
    return []
  }
  return [
    "\(battery.isACPowered() ? "ACPowered" : "NotACPowered")",
    "\(battery.isCharging() ? "Charging" : "NotCharging")",
    "\(battery.charge())%"
  ]
}

// OTHER INFO

//var battery = Battery()
//if battery.open() != kIOReturnSuccess { exit(0) }
//
//print("\n-- BATTERY --")
//print("\tAC POWERED:      \(battery.isACPowered())")
//print("\tCHARGED:         \(battery.isCharged())")
//print("\tCHARGING:        \(battery.isCharging())")
//print("\tCHARGE:          \(battery.charge())%")
//print("\tCAPACITY:        \(battery.currentCapacity()) mAh")
//print("\tMAX CAPACITY:    \(battery.maxCapactiy()) mAh")
//print("\tDESGIN CAPACITY: \(battery.designCapacity()) mAh")
//print("\tCYCLES:          \(battery.cycleCount())")
//print("\tMAX CYCLES:      \(battery.designCycleCount())")
//print("\tTEMPERATURE:     \(battery.temperature())°C")
//print("\tTIME REMAINING:  \(battery.timeRemainingFormatted())")
//
//_ = battery.close()
