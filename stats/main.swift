//
//  main.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation

/// Returns this keys line by line, each line defined as JSON [
/// [
///   "battery",
///   "boottime",
///   "cpuUsage",
///   "diskUsage",
///   "fans",
///   "memoryUsage",
///   "network",
///   "processinfo",
///   "uptime"
/// ]

print("""
{
""")

let batteryStatus = getBattery()
print("""
\t"battery":\(batteryStatus),
""")

let bootTime: String = (try? getFormattedBootTimeDate()) ?? ""
print("""
\t"boottime":"\(bootTime)",
""")

let cpuUsage = getCPUUsage()
print("""
\t"cpuUsage":\(cpuUsage),
""")

let diskUsage = getDiskUsage()
print("""
\t"diskUsage":\(diskUsage),
""")

let fans = getFans()
print("""
\t"fans": "\(fans)",
""")

/// memoryUsage
let memoryUsage = getMemory()
print("""
\t"memoryUsage": "\(memoryUsage)",
""")

/// network
let network = getNetwork()
print("""
\t"network": "\(network)",
""")

/// processinfo
let processinfo = getProcessInfo()
print("""
\t"processinfo": "\(processinfo)",
""")

/// uptime
let uptime = getUptime()
print("""
\t"uptime": "\(uptime)"
""")

print("""
}
""")
