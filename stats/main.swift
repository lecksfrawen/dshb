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

let batteryStatus = getBattery()
print("""
"battery":\(batteryStatus)
""")

let bootTime: String = (try? getFormattedBootTimeDate()) ?? ""
print("""
"boottime":"\(bootTime)"
""")

let cpuUsage = getCPUUsage()
print("""
"cpuUsage":\(cpuUsage)
""")

let diskUsage = getDiskUsage()
print("""
"diskUsage":[]
""")

let fans = getFans()
print("""
"fans": "\(fans)"
""")

/// memoryUsage
let memoryUsage = ""
print("""
"memoryUsage": "\(memoryUsage)"
""")

/// network
let network = ""
print("""
"network": "\(network)"
""")

/// processinfo
let processinfo = ""
print("""
"processinfo": "\(processinfo)"
""")

/// uptime
let uptime = ""
print("""
"uptime": "\(uptime)"
""")
