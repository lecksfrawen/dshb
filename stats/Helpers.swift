//
//  Helpers.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation

enum SystemReadErrors: Error {
  case noBoottime
  case noCPUUsage
}

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

// MARK: - Boottime date

//let uptime = System.uptime()
//print("\tUPTIME:          \(uptime.days)d \(uptime.hrs)h \(uptime.mins)m " +
//                            "\(uptime.secs)s")
func getBootTimeDate() throws -> Date {
  let uptime: (days: Int, hrs: Int, mins: Int, secs: Int) = System.uptime()
  let currentDate: Date = Date()
  guard let dateMinusDays: Date = Calendar.current.date(byAdding: .day, value: -uptime.days, to: currentDate),
    let dateMinusHours = Calendar.current.date(byAdding: .hour, value: -uptime.hrs, to: dateMinusDays),
    let dateMinusMinutes = Calendar.current.date(byAdding: .minute, value: -uptime.mins, to: dateMinusHours),
    let bootTimeDate = Calendar.current.date(byAdding: .second, value: -uptime.secs, to: dateMinusMinutes)
  else {
    throw SystemReadErrors.noBoottime
  }
    
  return bootTimeDate
}

/// Boottime
/// Needed for uptime status
/// Output:
/// ```json
/// "boottime":"21:48, Aug 10"
/// ```
/// - Throws: Error No boot time error
/// - Returns: bootTime Formatted string of the bottime
func getFormattedBootTimeDate() throws -> String {
  let bootTimeDate = try getBootTimeDate()
  let formatString = "HH:mm, MMM d"
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = formatString
  let bootTime: String = dateFormatter.string(from: bootTimeDate)
  return bootTime
}

// MARK: - CPU

//print("\n-- CPU --")
//print("\tPHYSICAL CORES:  \(System.physicalCores())")
//print("\tLOGICAL CORES:   \(System.logicalCores())")
//
//var sys = System()
//let cpuUsage = sys.usageCPU()
//print("\tSYSTEM:          \(Int(cpuUsage.system))%")
//print("\tUSER:            \(Int(cpuUsage.user))%")
//print("\tIDLE:            \(Int(cpuUsage.idle))%")
//print("\tNICE:            \(Int(cpuUsage.nice))%")

/// Lists CPU usage of the mac
///
/// Output:
/// ```json
/// "cpuUsage":[
///   [
///     1.9095128173673819,
///     0.0,
///     94.35262739918512
///   ]
/// ]
/// ```
/// - Returns: A list containing a list with `[system, nice, idle]` CPU usage.
func getCPUUsage() -> String {
  var sys = System()
  let cpuUsage = sys.usageCPU()
  let systemUsage = cpuUsage.system
  let niceUsage = cpuUsage.nice
  let idleUsage = cpuUsage.idle
  let cpuUsageString = """
[[\(systemUsage),\(niceUsage),\(idleUsage)]]
"""
  return cpuUsageString
}

// MARK: - Disk

/// A list of lists, each list containing the data of a disk
///
/// Format: `[["name", "use", "free"]]`
/// Output:
/// ```json
/// "diskUsage":[
///   [
///     "eticloud.com_Yosemite",
///     "276.5<span class='size'>GB</span>",
///     "42.63<span class='size'>GB</span>"
///   ]
/// ]
/// ```
func getDiskUsage() -> String {
  // TODO: @hectorddmx: Implement this later
  ""
}



// MARK: - Fans

/// Gets the information for the fans
///
/// Format: `[["fan name", "rpm"]]`
/// Output:
/// ```json
/// "fans": [
///  [
///    "Exhaust", #fan name
///    "1795rpm", #rpm
///  ]
///]
/// ```
func getFans() -> String {
  return ""
}


//
//
//print("\n-- MEMORY --")
//print("\tPHYSICAL SIZE:   \(System.physicalMemory())GB")
//
//let memoryUsage = System.memoryUsage()
//func memoryUnit(_ value: Double) -> String {
//    if value < 1.0 { return String(Int(value * 1000.0))    + "MB" }
//    else           { return NSString(format:"%.2f", value) as String + "GB" }
//}
//
//print("\tFREE:            \(memoryUnit(memoryUsage.free))")
//print("\tWIRED:           \(memoryUnit(memoryUsage.wired))")
//print("\tACTIVE:          \(memoryUnit(memoryUsage.active))")
//print("\tINACTIVE:        \(memoryUnit(memoryUsage.inactive))")
//print("\tCOMPRESSED:      \(memoryUnit(memoryUsage.compressed))")
//
//
//print("\n-- SYSTEM --")
//print("\tMODEL:           \(System.modelName())")
//
////let names = System.uname()
////print("\tSYSNAME:         \(names.sysname)")
////print("\tNODENAME:        \(names.nodename)")
////print("\tRELEASE:         \(names.release)")
////print("\tVERSION:         \(names.version)")
////print("\tMACHINE:         \(names.machine)")
//

//
//let counts = System.processCounts()
//print("\tPROCESSES:       \(counts.processCount)")
//print("\tTHREADS:         \(counts.threadCount)")
//
//let loadAverage = System.loadAverage().map { NSString(format:"%.2f", $0) }
//print("\tLOAD AVERAGE:    \(loadAverage)")
//print("\tMACH FACTOR:     \(System.machFactor())")
//
//
//print("\n-- POWER --")
//let cpuThermalStatus = System.CPUPowerLimit()
//
//print("\tCPU SPEED LIMIT: \(cpuThermalStatus.processorSpeed)%")
//print("\tCPUs AVAILABLE:  \(cpuThermalStatus.processorCount)")
//print("\tSCHEDULER LIMIT: \(cpuThermalStatus.schedulerTime)%")
//
//print("\tTHERMAL LEVEL:   \(System.thermalLevel().rawValue)")
//
