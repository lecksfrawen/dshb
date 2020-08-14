//
//  Battery.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation


// MARK: - Battery

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

/// Since mac minis and mac pro have no batteries I can skip this for now
/// Output: `"battery":[]`
func getBattery() -> String {
  // TODO: @hectorddmx: Implement this later
  "[]"
}
