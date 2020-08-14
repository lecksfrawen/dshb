//
//  main.swift
//  stats
//
//  Created by Lecksfrawen on 8/13/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

import Foundation

var hasSMC = false

do {
  try SMCKit.open()
  hasSMC = true
}
catch {
  print(error)  
}

// This is set from python
let load: String = getLoadAverage()

let fans: [[FanOrTemp]] = getFans()

// This was set from iStats, so needs to be added
let temp: [[FanOrTemp]] = [
  [
    FanOrTemp.double(10.0)
  ]
]

let uptime: String = getUptime()

let network: [[String]] = getNetwork()

let battery: [String] = getBattery()

let cpuUsage: [[CPUUsage]] = getCPUUsage()

let boottime: String = (try? getFormattedBootTimeDate()) ?? ""

let diskUsage: [[String]] = getDiskUsage()

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

do {
  let jsonData = try encoder.encode(systemData)
  guard let jsonString = String(data:jsonData, encoding: .utf8) else {
    throw InputError.noSystemData
  }
  print(jsonString)
} catch {
  let emptySystemData = """
  {
    "systatus": nil
    "error": "\(error.localizedDescription)"
  }
  """
  print(emptySystemData)
}

if hasSMC {
  let _ = SMCKit.close()
}
