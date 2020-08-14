//
//  main.swift
//  stats
//
//  Created by hdb on 8/13/20.
//  Copyright © 2020 beltex. All rights reserved.
//

import Foundation

enum InputError: Error {
  case noSystemData
}

/// Returns this keys line by line, each line defined as JSON
/// ```json
/// {
///   "battery" : [],
///   "boottime": [],
///   "cpuUsage",
///   "diskUsage",
///   "fans",
///   "memoryUsage",
///   "network",
///   "processinfo",
///   "uptime"
/// }
/// ```
let load: String = ""

let fans: [[FanInfo]] = [
  [
    FanInfo.double(10.0)
  ]
]

let temp: [[FanInfo]] = [
  [
    FanInfo.double(10.0)
  ]
]

let uptime: String = getUptime()

let network: [[String]] = []

let battery: [String] = []

let cpuUsage: [[CPUUsage]] = []

let boottime: String = (try? getFormattedBootTimeDate()) ?? ""

let diskUsage: [[String]] = []

let memoryUsage: [MemoryUsage] = []

let sysStatus = Systatus(
  load: load,
  fans: fans,
  uptime: uptime,
  temps: temp,
  network: network,
  battery: battery,
  cpuUsage: cpuUsage,
  boottime: boottime,
  diskUsage: diskUsage,
  memoryUsage: memoryUsage
)

let systemData = SystemData(systatus: sysStatus)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let emptySystemData = """
{
  "systatus": {}
}
"""

do {
  let jsonData = try encoder.encode(systemData)
  guard let jsonString = String(data:jsonData, encoding: .utf8) else {
    throw InputError.noSystemData
  }
  print(jsonString)
} catch {
  print(emptySystemData)
}

