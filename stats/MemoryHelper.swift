//
//  MemoryHelper.swift
//  stats
//
//  Created by Lecksfrawen on 8/13/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

import Foundation


// MARK: - Memory

//
//
//print("\n-- MEMORY --")
//print("\tPHYSICAL SIZE:   \(System.physicalMemory())GB")
//

fileprivate func memoryUnit(_ value: Double) -> (value: String, unit: String) {
    if value < 1.0 { return (String(Int(value * 1000.0)), "MB") }
    else           { return (NSString(format:"%.2f", value) as String, "GB") }
}

func getMemory() -> [MemoryUsage] {
  let memoryUsage = System.memoryUsage()
  
  let free = memoryUnit(memoryUsage.free)
  let compressed = memoryUnit(memoryUsage.compressed)
  let active = memoryUnit(memoryUsage.active)
  let inactive = memoryUnit(memoryUsage.inactive)
  let wired = memoryUnit(memoryUsage.wired)
  
  let memoryData = MobileHelpers.memoryInfo
  let pageins = memoryData["pageins"] as? Double ?? 0.0
  let pageouts = memoryData["pageouts"] as? Double ?? 0.0
  let swaptotal = memoryData["swaptotal"] as? Double ?? 0.0
  let swapused = memoryData["swapused"] as? Double ?? 0.0
  
  return [
    MemoryUsage.string("\(free.value)<span class='size'>\(free.unit)</span>"),
    MemoryUsage.string("\(compressed.value)<span class='size'>\(compressed.unit)</span>"),
    MemoryUsage.string("\(active.value)<span class='size'>\(active.unit)</span>"),
    MemoryUsage.string("\(inactive.value)<span class='size'>\(inactive.unit)</span>"),
    MemoryUsage.string("\(wired.value)<span class='size'>\(wired.unit)</span>"),
    MemoryUsage.double(0.0),
    MemoryUsage.stringArray(["\(pageins)","0"]),
    MemoryUsage.stringArray(["\(pageouts)","0"]),
    MemoryUsage.string("0<span class='size'>MB</span>"),
    MemoryUsage.string("\(swapused)<span class='size'>MB</span>/\(swaptotal)<span class='size'>MB</span>"),
  ]
}
