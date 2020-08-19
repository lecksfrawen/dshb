//
//  main.swift
//  stats
//
//  Created by Lecksfrawen on 8/13/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

import Foundation

struct MobileHelpers {
  static var systemInfo: Dictionary = STSSystemHelper().obtainDataSystatus()
  static var memoryInfo: Dictionary = STSSystemHelper.obtainMemoryData()
}
//let systemInfoJSON = try JSONSerialization.data(withJSONObject: MobileHelpers.systemInfo, options: .prettyPrinted)
//print(String(data:systemInfoJSON, encoding: .utf8) ?? "")

var hasSMC = false

do {
  try SMCKit.open()
  hasSMC = true
}
catch {
  print(error)
}

// This is set from python I think, still I'll send it.
let load: String = getLoadAverage()

let fans: [[FanOrTemp]] = getFans()

// This was set from iStats, so needs to be added
let temp: [[FanOrTemp]] = getTemperature()

let uptime: String = getUptime()

let network: [[Network]] = getNetwork()

let battery: [String] = getBattery()

let cpuUsage: [[CPUUsage]] = getCPUUsage()

let boottime: String = (try? getFormattedBootTimeDate()) ?? ""

let diskUsage: [[String]] = getDiskUsage()

let memoryUsage: [MemoryUsage] = getMemory()

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
